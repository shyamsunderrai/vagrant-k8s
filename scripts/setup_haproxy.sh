#!/bin/bash

theIPaddress=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
master1=$(nslookup k8s-master-1 | egrep Address | tail -1 | cut -d":" -f2 | xargs)
master2=$(nslookup k8s-master-2 | egrep Address | tail -1 | cut -d":" -f2 | xargs)
master3=$(nslookup k8s-master-3 | egrep Address | tail -1 | cut -d":" -f2 | xargs)

sed -i "s:bind IPADDR:bind ${theIPaddress}\:6443:g" /home/vagrant/sample.file
sed -i "s:k8s-master-1 IPADDR: k8s-master-1 ${master1}\:6443:g" /home/vagrant/sample.file
sed -i "s:k8s-master-2 IPADDR: k8s-master-2 ${master2}\:6443:g" /home/vagrant/sample.file
sed -i "s:k8s-master-3 IPADDR: k8s-master-3 ${master3}\:6443:g" /home/vagrant/sample.file



sudo cp /home/vagrant/sample.file /etc/haproxy/haproxy.cfg

sudo systemctl daemon-reload
sudo systemctl enable haproxy
sudo systemctl start haproxy
