#!/usr/bin/env bash

VERSION=""
v="latest"
if [[ -n $1 ]]; then
    VERSION="==$1"
    v=$1
fi

if [[ $2 == "true" ]]; then
    echo "Installing HashiCorp terraform.."
    
    if [[ -n $3 ]]; then
        TERRAFORM_REQUESTED_VERSION=$3
    else
        TERRAFORM_REQUESTED_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
        
        # Get the latest terraform unless there is a specific terraform version given
        tf_file="terraform_${TERRAFORM_REQUESTED_VERSION}_linux_amd64"
        tf_download_url="https://releases.hashicorp.com/terraform/${TERRAFORM_REQUESTED_VERSION}/${tf_file}.zip"
        
        # Install terraform
        echo "Installing terraform v${TERRAFORM_REQUESTED_VERSION}"
        curl -s -O $tf_download_url
        unzip $tf_file.zip
        mv terraform /usr/local/bin
        chmod +x /usr/local/bin/terraform
        echo "Installed terraform v${TERRAFORM_REQUESTED_VERSION}"
    fi
fi

# Required for installing terraform-compliance...
sudo apt-get install -y python3-setuptools python3-wheel

# Install terraform-compliance
echo "Installing terraform-compliance$VERSION version $v"
pip3 install -q wheel terraform-compliance$VERSION
