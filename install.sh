#!/usr/bin/env bash

VERSION=""
v="latest"
if [[ -n $1 ]]; then
    VERSION="==$1"
    v=$1
fi

# Required for installing terraform-compliance...
sudo apt-get install -y python3-setuptools python3-wheel

# Install terraform-compliance
echo "Installing terraform-compliance$VERSION version $v"
pip3 install -q wheel terraform-compliance$VERSION

ln -s /home/runner/.local/bin/terraform-compliance /usr/local/bin
