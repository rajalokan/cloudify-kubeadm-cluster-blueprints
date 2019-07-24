#! /bin/bash -e

ctx logger info "Bootstrapping k8s master node"

# Install wget
sudo apt install -y wget || sudo yum install -y wget
#
# setup okanstack
if [[ ! -f /tmp/okanstack.sh ]]; then
    wget -q https://raw.githubusercontent.com/rajalokan/okanstack/master/okanstack.sh -O /tmp/okanstack.sh
fi
source /tmp/okanstack.sh
#
# Preconfigure the instance
preconfigure k8smaster

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

# 3. Bootstrap kubeadm to initialize the cluster using the IP range for Flannel
POD_NETWORK_CIDR="10.244.0.0/16"
#
sudo kubeadm init --pod-network-cidr=${POD_NETWORK_CIDR}
#
mkdir -p ${HOME}/.kube
sudo cp /etc/kubernetes/admin.conf ${HOME}/.kube/config
sudo chown $(id -u):$(id -g) ${HOME}/.kube/config
#
kubectl version

# 4. Join worker nodes
sudo kubeadm join <ip> --token ${some_token} --provider_token=${provider_token}


# 5. Add flannel networking
# Get nodes
kubectl get nodes
#
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
#
KUBE_FLANNEL_URL="https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml"
kubectl apply -f ${KUBE_FLANNEL_URL}
#
watch kubectl get nodes


# 6. Verify
kubectl create deployment nginx --image=nginx
