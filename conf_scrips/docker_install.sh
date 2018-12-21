## Uninstall Docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get purge docker-ce
sudo rm -rf /var/lib/docker

## Install prerequisites.
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

## Download GPG key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

## Add docker apt repository.
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

## Install docker.
sudo apt-get update && apt-get install docker-ce=18.06.0~ce~3-0~ubuntu

# Setup daemon.
sudo cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo groupadd docker
sudo usermod -aG docker $USER
docker run hello-world
