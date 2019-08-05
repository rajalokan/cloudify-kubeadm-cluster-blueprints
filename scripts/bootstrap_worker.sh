#! /bin/bash -e

ctx logger info "Bootstrapping k8s worker node"

# Install wget
sudo apt install -y wget || sudo yum install -y wget
# setup okanstack
if [[ ! -f /tmp/okanstack.sh ]]; then
    wget -q https://raw.githubusercontent.com/rajalokan/okanstack/master/okanstack.sh -O /tmp/okanstack.sh
fi
source /tmp/okanstack.sh
# Preconfigure the instance
#preconfigure k8sworker

# 1. Install docker
DOCKER_GPG_KEY_URL="https://download.docker.com/linux/ubuntu/gpg"
DOCKER_APT_URL="https://download.docker.com/linux/ubuntu"
#
curl -fsSL ${DOCKER_GPG_KEY_URL} | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] ${DOCKER_APT_URL} $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo apt-mark hold docker-ce

# 2. Install kubectl, kubeadm & kubelet
K8S_GPG_KEY_URL="https://packages.cloud.google.com/apt/doc/apt-key.gpg"
K8S_APT_URL="https://apt.kubernetes.io"
#
curl -fsSL ${K8S_GPG_KEY_URL} | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb ${K8S_APT_URL} kubernetes-xenial main
EOF
sudo apt update
sudo apt install -y kubectl kubeadm kubelet
sudo apt-mark host kubectl kubeadm kubelet
