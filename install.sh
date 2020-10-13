#!/usr/bin/env bash

VERSION=""
v="latest"
if [[ -n $1 ]]; then
    VERSION="==$1"
    v=$1
fi

sudo apt-get install -y python3-setuptools python3-wheel
echo "Installing terraform-compliance$VERSION version $v"
pip3 install wheel terraform-compliance$VERSION
