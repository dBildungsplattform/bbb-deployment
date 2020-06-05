#!/bin/bash -xe

pwFile="$1"

node_exporter_version=1.0.0-rc.1
#Create User
id -u node_exporter &>/dev/null || adduser --no-create-home --disabled-login --shell /bin/false --gecos "Node Exporter User" node_exporter
#Download Binary
wget https://github.com/prometheus/node_exporter/releases/download/v$node_exporter_version/node_exporter-$node_exporter_version.linux-amd64.tar.gz

#Untar
tar xvzf node_exporter-$node_exporter_version.linux-amd64.tar.gz
#Copy Expoter
cp node_exporter-$node_exporter_version.linux-amd64/node_exporter /usr/local/bin/
#Assign Ownership Again
chown node_exporter:node_exporter /usr/local/bin/node_exporter

#Creating Service File
cat <<- EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.config="/usr/local/bin/nodeExporter_webconfig.yml"
[Install]
WantedBy=multi-user.target
EOF

echo "set password in webconfig"

quoteSubst() {
  IFS= read -d '' -r < <(sed -e ':a' -e '$!{N;ba' -e '}' -e 's/[&/\]/\\&/g; s/\n/\\&/g' <<<"$1")
  printf %s "${REPLY%$'\n'}"
}

# ESCAPED_REPLACE=$(echo $REPLACE | sed -e 's/[\/&]/\\&/g')
USER=`cat $pwFile | cut -d ":" -f1`
PASS=`cat $pwFile | cut -d ":" -f2`

sudo sed -i "s/###credentials###/$USER: $(quoteSubst "$PASS")/g" /usr/local/bin/nodeExporter_webconfig.yml

#Reload and Start
systemctl daemon-reload;.
