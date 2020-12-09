#!/bin/bash

domainName="$1"
scaleliteDns="$2"
keyFile="$3"

# cleanup
rm -f servers.dat id.dat

bbbSecret=`bbb-conf --secret | grep Secret: | cut -d ":" -f2 | sed 's/ *$//g' | sed 's/^ *//g'`
bbbURL="https:"`bbb-conf --secret | grep URL:  | cut -d ":" -f3`"api"
echo "SECRET: $bbbSecret, URL: $bbbURL"

ssh -i $keyFile -oStrictHostKeyChecking=no root@$scaleliteDns.$domainName "docker exec --tty scalelite-api ./bin/rake servers" > servers.dat
sed -z -E -i -e 's/\r\n[[:blank:]]+/,/g' servers.dat

if grep $bbbURL servers.dat | grep -q $bbbSecret; then
    echo "Server $bbbURL already registered in scalelite"
    exit 0
else
    if grep -q $bbbURL servers.dat; then
	    echo "Server $bbbURL registered with wrong password, removing it"
	    grep $bbbURL servers.dat > id.dat
		sed -i 's/id: //g' id.dat
		bbbId=`cut -d "," -f1 id.dat`
		ssh -i $keyFile -oStrictHostKeyChecking=no root@$scaleliteDns.$domainName "docker exec --tty scalelite-api ./bin/rake servers:remove[$bbbId]"
	fi
    echo "Add server: $bbbURL to scalelite setup"
    ssh -i $keyFile -oStrictHostKeyChecking=no root@$scaleliteDns.$domainName "docker exec --tty scalelite-api ./bin/rake servers:add[$bbbURL,$bbbSecret]" > id.dat
    bbbId=`cat id.dat | grep id: | cut -d ":" -f2 | sed 's/ *$//g' | sed 's/^ *//g'`

    echo "Enable server with id [$bbbId]"
    ssh -i $keyFile -oStrictHostKeyChecking=no root@$scaleliteDns.$domainName "docker exec --tty scalelite-api ./bin/rake servers:enable[$bbbId]"

    echo "Poll server directly"
    ssh -i $keyFile -oStrictHostKeyChecking=no root@$scaleliteDns.$domainName "docker exec --tty scalelite-api ./bin/rake poll:servers"
fi
