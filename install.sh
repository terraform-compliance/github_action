#!/usr/bin/env bash

VERSION=""
v="latest"
if [[ -n $1 ]]; then
    VERSION="==$1"
    v=$1
fi

# Required for installing terraform-compliance...
echo "Installing required packages for terraform-compliance"
sudo apt-get install -y -qq python3-setuptools python3-wheel > /dev/null

# Install terraform-compliance
echo "Installing terraform-compliance$VERSION version $v"
pip3 install -q wheel terraform-compliance$VERSION

if [ ! -f /usr/local/bin/terraform-compliance ]; then
    sudo ln -s /home/runner/.local/bin/terraform-compliance /usr/local/bin
fi
