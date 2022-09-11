#!/bin/bash

##OS=xUbuntu_20.04
##CRIO_VERSION=1.25
OS=$1
CRIO_VERSION=$2

sudo echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
sudo echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

sudo curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION/$OS/Release.key | sudo apt-key add -
sudo curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key add -

sudo apt update 
sudo apt install cri-o cri-o-runc cri-tools -y

sudo rm -rf /etc/crio/crio.conf
sudo cat <<EOF >>/etc/crio/crio.conf 
[crio.runtime]
conmon_cgroup = "pod"
cgroup_manager = "systemd"
EOF

sudo systemctl enable crio.service
sudo systemctl daemon-reload
sudo systemctl start crio.service
