#!/bin/bash
#Package updates
sudo apt-get update
echo 'Install necesarry packages to use repo over HTTPS'

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

echo 'Add Dockers official GPG key'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo 'Set up stable repository'
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

echo 'Install docker packages'
sudo apt-get install docker-ce docker-ce-cli containerd.io -q -y

echo 'Docker Engine is installed now'
sudo apt-get update

echo 'Install Docker-Compose'
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

