#!/bin/bash

### Performing kubeadm init with crio and readying for flannel cni
sudo kubeadm init --pod-network-cidr=10.244.0.0/24 --cri-socket=unix:///var/run/crio/crio.sock

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
