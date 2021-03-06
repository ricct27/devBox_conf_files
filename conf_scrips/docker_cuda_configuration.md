# Install CUDA Nvidia Drivers


Verify the driver version
```console
nvidia-smi

cat /proc/driver/nvidia/version

nvcc -V
```


Install CUDA 
```console
sudo update-pciids

sudo apt-get install -y linux-headers-$(uname -r)

sudo apt-get install g++ freeglut3-dev build-essential libx11-dev \
    libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

cd Downloads

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_10.0.130-1_amd64.deb

sudo dpkg -i cuda-repo-ubuntu1604_10.0.130-1_amd64.deb

sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub

rm cuda-repo-ubuntu1604_10.0.130-1_amd64.deb
sudo apt-get update

sudo apt-get install -y cuda

echo "export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}" >> ~/.bashrc

echo "export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64 ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc
```

Verify the driver version
```console
nvidia-smi

cat /proc/driver/nvidia/version

nvcc -V
```

Test drivers
```console
cuda-install-samples-10.0.sh
```

Update Systembackba	
```console
systemback-cli
```


# Install Nvidia-Docker2
Remove privios versions
```console
sudo docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f

sudo apt-get purge -y nvidia-docker2
```

Add repository
```console
sudo curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
```



Install with Docker version compatible with kubernetes "apt-cache madison nvidia-docker2 nvidia-container-runtime"
```console
sudo apt-get install -y nvidia-docker2=2.0.3+docker18.06.0-1 nvidia-container-runtime=2.0.0+docker18.06.0-1

sudo pkill -SIGHUP dockerd

sudo groupadd docker

sudo usermod -aG docker $USER

docker --version
```

Test nvidia-smi with the latest official CUDA image
```console
sudo docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

Check docker cgroup
```console
docker info |grep -i cgroup
```

Update insertig the conf for Kubernetes
```console
sudo nano /etc/docker/daemon.json 
{
  ,"exec-opts": ["native.cgroupdriver=cgroupfs"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}

sudo mkdir -p /etc/systemd/system/docker.service.d
```

Restart docker.
```console
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo apt-mark hold docker-ce nvidia-docker2 nvidia-container-runtime
```

Test nvidia-smi with the latest official CUDA image
```console
docker run hello-world
sudo docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```







