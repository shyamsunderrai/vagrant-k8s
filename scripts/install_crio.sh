#!/bin/bash

##OS=xUbuntu_20.04
##CRIO_VERSION=1.25
OS=$1
CRIO_VERSION=$2

echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

mkdir -p /usr/share/keyrings
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

sudo apt-get update 
sudo apt-get install cri-o cri-o-runc cri-tools -y

sudo rm -rf /etc/crio/crio.conf
sudo cat <<EOF >>/etc/crio/crio.conf 
[crio.runtime]
conmon_cgroup = "pod"
cgroup_manager = "systemd"
EOF

sudo systemctl enable crio.service
sudo systemctl daemon-reload
sudo systemctl start crio.service
