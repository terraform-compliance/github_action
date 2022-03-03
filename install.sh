#!/usr/bin/env bash

VERSION=""
v="latest"
if [[ -n $1 ]]; then
    VERSION="==$1"
    v=$1
fi

INSTALLED_PATH="/home/runner/.local/bin/terraform-compliance"
if [[ -n $2 ]]; then
    INSTALLED_PATH=$2
fi

# Required for installing terraform-compliance...
echo "Installing required packages for terraform-compliance"
sudo apt-get install -y -qq python3-setuptools python3-wheel libxml2-dev libxslt-dev > /dev/null

# Install terraform-compliance
echo "Installing terraform-compliance$VERSION version $v"
pip3 install -q wheel terraform-compliance[faster_parsing]$VERSION


if [ ! -f /usr/local/bin/terraform-compliance ]; then
    sudo ln -s "$INSTALLED_PATH" /usr/local/bin
fi
