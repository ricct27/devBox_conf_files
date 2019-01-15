https://www.youtube.com/watch?v=UWg3ORRRF60
https://docs.nvidia.com/datacenter/kubernetes-install-guide/index.html


# Before You Begin 
- Important Consider having an isolated network configuration
- Ensure that NVIDIA drivers are loaded
- Ensure that a supported version of Docker is installed.
- Ensure that NVIDIA Container Runtime for Docker 2.0 is installed.
- Is recommend that your master nodes not be equipped with GPUs and to only run the master components, such as the following: 
   -Scheduler
   -API-server
   -Controller Manager

# Set on all nodes

Disable Swap
```console
sudo swapoff -a
```
Comment the swap line
```console
sudo nano /etc/fstab
```

Set the hostnames
```console
sudo nano /etc/hostname
```

Associate hostname with the static IP
```console
sudo nano /etc/hosts
```

Install openSSH server
```console
sudo apt-get install openssh-server
```
# Master Nodes

Delete old things

Add the official GPG keys.
```console
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
curl -s -L https://nvidia.github.io/kubernetes/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/kubernetes/ubuntu16.04/nvidia-kubernetes.list |\
	sudo tee /etc/apt/sources.list.d/nvidia-kubernetes.list
	
sudo apt update
```

Install packages.
```console
VERSION=1.10.11+nvidia
sudo apt install -y kubectl=${VERSION} kubelet=${VERSION} \
     kubeadm=${VERSION} helm=${VERSION}
sudo apt-mark hold kubelet kubeadm kubectl
```

To Verify if Kubernetes (kubelet, kubectl, and kubeadm) is Installed Properly
```console
dpkg -l '*kube*'| grep +nvidia
$ls /etc/kubeadm
```

Check docker cgroup
```console
docker info |grep -i cgroup
```

Edit file for configurin the cgroup of kubelet https://kubernetes.io/docs/setup/independent/troubleshooting-kubeadm/
```console
sudo nano /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
```

Possibile entries
```console
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
```

Check the status af Kubernetes
```console
sudo systemctl status kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet
sudo kubeadm reset
rmdir $HOME/.kube
sudo systemctl start kubelet
```

Check for Kubelet errors
```console
sudo journalctl -xeu kubelet
```

Start your cluster.
```console
sudo kubeadm init --ignore-preflight-errors=all --config /etc/kubeadm/config.yml
```

Alternative cluster initialization
```console
sudo kubeadm init --apiserver-advertise-address=192.168.1.81 --ignore-preflight-errors=all --config /etc/kubeadm/config.yml
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.1.81 --ignore-preflight-errors=all --kubernetes-version stable-1.10
```

Run as normal User no Root
```console
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

For errors with cgroup compatibility between k8 and docker chance
```console
sudo nano /etc/docker/daemon.json
```

Checking Cluster Health
```console
kubectl get all --all-namespaces
kubectl get nodes
kubectl describe nodes | grep -B 3 gpu
```

To retrieve the joining token
```console
sudo kubeadm token create --print-join-command
```

# -------------------Worker Nodes---------------------------------

Check that SWAP and host names
check Nvidia-Docker  https://github.com/NVIDIA/nvidia-docker

Add theollowing
```conse
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
curl -s -L https://nvidia.github.io/kubernetes/gpgkey | sudo apt-key add -
curl -s -L https://vidia.github.io/kubernetes/ubuntu16.04/nvidia-kubernetes.list |\
      sudo tee /etc/apt/sources.list.d/nvidia-kubernetes.list

sudo apt update
```

Install packages
```console
VERSION=1.10.11+nvidia 
sudo apt install -y kubectl=${VERSION} kubelet=${VERSION} \
      kubeadm=${VERSION} helm=${VERSION}
```

```console
sudo apt-mark hold kubelet kubeadm kubectl
```

Verify if Kubernetes (kubelet, kubectl, and kubeadm) is Installed Properly
```console
dpkg -l '*kube*'| grep +nvidia
$ls /etc/kubeadm
```

Retrieve joining token from the Master
```console
sudo kubeadm token create --print-join-command
```

Join the worker node to the cluster with a command similar to the following
 ```console
 <join-token>  --ignore-preflight-errors=all
```

In case of Swap and Cgroup erros edit the file https://kubernetes.io/docs/setup/independent/troubleshooting-kubeadm/
```console
sudo nano /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
```

Possibil entries
```console
####Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
####Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
```

Check the k8 status
```console
sudo systemctl status kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet
sudo kubeadm reset
sudo systemctl start kubelet
```

Check the Nodes and GPUs
```console
kubectl describe nodes
kubectl get nodes
kubectl describe nodes | grep -B 3 gpu
```

# Tear down K8 
```console
kubectl drain k8- --delete-local-data --force --ignore-daemonsets
kubectl delete node k8-
sudo kubeadm reset
sudo iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
sudo rm -r $HOME/.kube/
```

# Controlling your cluster from machines other than the master
```console
scp root@<master ip>:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf get node
```


# Proxying API Server to localhost
```console
scp root@<master ip>:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf proxy
```

You can now access the API Server locally at http://localhost:8001/api/v1


# Set up Kubectl Autocomplete 
https://kubernetes.io/docs/reference/kubectl/cheatsheet/
```console
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
```






































