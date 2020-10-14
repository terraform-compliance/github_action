#!/usr/bin/env bash

VERSION=""
v="latest"
if [[ -n $1 ]]; then
    VERSION="==$1"
    v=$1
fi

# Required for installing terraform-compliance...
sudo apt-get install -y python3-setuptools python3-wheel

# Get the latest terraform unless there is a specific terraform version given

# Install terraform

# Install terraform-compliance
echo "Installing terraform-compliance$VERSION version $v"
pip3 install -q wheel terraform-compliance$VERSION
