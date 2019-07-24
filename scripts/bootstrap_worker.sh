#! /bin/bash -e

ctx logger info "Bootstrapping k8s worker node"
sudo apt install -y wget || sudo yum install -y wget

# setup okanstack
if [[ ! -f /tmp/okanstack.sh ]]; then
    wget -q https://raw.githubusercontent.com/rajalokan/okanstack/master/okanstack.sh -O /tmp/okanstack.sh
fi
source /tmp/okanstack.sh

# Preconfigure the instance
preconfigure k8sworker

# 1. Install docker
docker_gpg_key_url="https://download.docker.com/linux/ubuntu/gpg"
docker_apt_url="https://download.docker.com/linux/ubuntu"
#
curl -fsSL ${docker_gpg_key_url} | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] ${docker_apt_url} $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo apt-mark hold docker-ce

# 2. Install kubectl, kubeadm & kubelet
k8s_gpg_key_url="https://packages.cloud.google.com/apt/doc/apt-key.gpg"
k8s_apt_url="https://apt.kubernetes.io"
#
curl -fsSL ${k8s_gpg_key_url} | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb ${k8s_apt_url} kubernetes-xenial main
EOF
sudo apt update
sudo apt install -y kubectl kubeadm kubelet
sudo apt-mark host kubectl kubeadm kubelet
