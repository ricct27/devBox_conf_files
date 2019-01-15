# Install Docker 18.06

Remove previous versions
```console
sudo apt-get remove docker docker-engine docker.io docker-ce
sudo apt-get purge docker-ce
sudo rm -rf /var/lib/docker
```

Install prerequisites.
```console
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```

Download GPG key.
```console
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
```

Add docker apt repository.
```console
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

Install docker.
```console
sudo apt-get update && apt-get install docker-ce=18.06.0~ce~3-0~ubuntu
```

To prevent future (auto) updates
```console
sudo apt-mark hold docker-ce
```

Setup daemon. This is overriten when istalling the nvidia-docker
```console
sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d
```

Restart docker.
```console
sudo systemctl daemon-reload

sudo systemctl restart docker

sudo systemctl status docker

sudo groupadd docker

sudo usermod -aG docker $USER

docker run hello-world
```




















