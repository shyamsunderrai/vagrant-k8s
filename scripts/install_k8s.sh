#!/bin/bash

sudo apt install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

### sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

### Backup scripts in case the one above does not work
sudo sed -i '$anet\.ipv4\.ip\_forward \= 1' /etc/sysctl.conf
sudo sed -i '$anet\.bridge\.bridge\-nf\-call\-iptables \= 1' /etc/sysctl.conf
sudo sed -i '$anet\.bridge\.bridge\-nf\-call\-ip6tables \= 1' /etc/sysctl.conf
sudo sysctl -p

sudo sed -i "s:.*swap.*::g" /etc/fstab 
sudo swapoff -a
