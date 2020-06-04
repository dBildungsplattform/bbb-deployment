#!/bin/bash -xe
node_exporter_version=1.0.0-rc.0
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
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF
#Reload and Start

systemctl daemon-reload;
systemctl enable node_exporter
systemctl start node_exporter
