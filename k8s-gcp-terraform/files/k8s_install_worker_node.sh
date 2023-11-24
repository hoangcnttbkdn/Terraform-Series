#!/bin/bash

sudo apt-get update
echo "....................swapoff"

swapoff -a

echo "....................install docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update
sudo apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo usermod -aG docker ${USER}

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sleep 30s

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
sudo mv ~/kubernetes.list /etc/apt/sources.list.d

sudo apt-get update

echo ".....................Installing kubeadm kubelet kubectl"
sudo apt-get install -y kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo ".......................Restart kubelet"
sudo systemctl daemon-reload
sudo systemctl restart kubelet

sudo apt-get update
sudo rm /etc/containerd/config.toml
sudo systemctl enable containerd
sudo systemctl restart containerd

echo ".......................Execute sucessfully"