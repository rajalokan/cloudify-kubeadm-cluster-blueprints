#! /bin/bash -e

ctx logger info "Bootstrapping k8s worker node"
sudo apt install -y wget || sudo yum install -y wget

if [[ ! -f /tmp/okanstack.sh ]]; then
    wget -q https://raw.githubusercontent.com/rajalokan/okanstack/master/okanstack.sh -O /tmp/okanstack.sh
fi
source /tmp/okanstack.sh

# Preconfigure the instance
preconfigure worker 
