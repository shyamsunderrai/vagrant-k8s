# Vagrant Kubernetes + CRI-O

Since removal of dockershim in Kubernetes, using an alternate runtime is non-trivial. Following setup is specific to Mac OSX users with on M1/M2 processors and [parallels](https://www.parallels.com/products/desktop/)provisioner for virtual machines. 

### Pre-requisites for this setup

<ul>
  <li> Parallels Desktop (for Mac) </li> 
  <li> vagrant-parallels => 2.2.5 </li>
  <li> Vagrant => 2.3.0 </li>
  <li> git => 2.32.1 </li>
</ul>


## Steps to setup the VMs(ubuntu 20.04), cri-o and kubernetes

### Clone the git repo
``` 
git clone https://github.com/shyamsunderrai/vagrant-k8s.git
cd vagrant-k8s
```

### Bring up the cluster // This might take about 8-9 minutes
```
vagrant up
```

### Log into master host // If ssh keys are properly defined, you should be able to ssh without keys or password
```
ssh vagrant@k8s-master-1
```

### Initialize the kubernetes cluster using kubeadm
```
sudo kubeadm init --pod-network-cidr=10.244.0.0/24 --cri-socket=unix:///var/run/crio/crio.sock
```

If everything goes well, you should be able to get an output like this
```
 Your Kubernetes control-plane has initialized successfully!

 To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.211.55.120:6443 --token ctdss9.anuu3lfsjqhvzs6a \
	--discovery-token-ca-cert-hash sha256:22a8afd5f62b730f936ec93a116baf0bf2e81f5c2ccce3968bb64c8244de7d64 
```


### Sudo as root to speed things up and validate your setup on control plane
```
sudo su 
export KUBECONFIG=/etc/kubernetes/admin.conf
```

Desired output
```
root@k8s-master-1:/home/vagrant# kubectl get nodes
NAME           STATUS   ROLES           AGE     VERSION
k8s-master-1   Ready    control-plane   5m44s   v1.25.0
```

### Sequentially ssh to k8s-worker-1 and k8s-worker-2, either from your mac terminal OR from k8s-master-1 and add workers using kubeadm join command output
```
sudo kubeadm join 10.211.55.120:6443 --token ctdss9.anuu3lfsjqhvzs6a --discovery-token-ca-cert-hash sha256:22a8afd5f62b730f936ec93a116baf0bf2e81f5c2ccce3968bb64c8244de7d64
```

If everything completed successfully, you should see something like the following
```
 This node has joined the cluster:
 * Certificate signing request was sent to apiserver and a response was received.
 * The Kubelet was informed of the new secure connection details.
 Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

### ssh back to k8s-master-1 to validate the setup
```
sudo su
kubectl get nodes
```

Desired output
```
 root@k8s-master-1:/home/vagrant# kubectl get nodes
NAME           STATUS   ROLES           AGE     VERSION
k8s-master-1   Ready    control-plane   12m     v1.25.0
k8s-worker-1   Ready    <none>          2m48s   v1.25.0
k8s-worker-2   Ready    <none>          18s     v1.25.0
```

### !! Enjoy working with your Kubernetes Cluster !!


