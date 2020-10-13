#!/usr/bin/env bash

VERSION=""
v="latest"
if [[ -n $1 ]]; then
    VERSION="==$1"
    v=$1
fi

echo "Installing terraform-compliance version $v"
pip3 install -q terraform-compliance$VERSION
