#!/usr/bin/env bash

PARAMETERS="/home/runner/.local/bin/terraform-compliance"

if [[ -n $1 ]]; then
    PLAN_FILE="$GITHUB_WORKSPACE/$1"
    PARAMETERS+=" -p $PLAN_FILE"
fi

if [[ -n $2 ]]; then
    PARAMETERS+=" -f git:$2"
fi

if [[ -n $3 ]]; then
    PARAMETERS+=" -q"
fi

if [[ -n $4 ]]; then
    PARAMETERS+=" -n"
fi

if [[ -n $5 ]]; then
    PARAMETERS+=" -S"
fi

if [[ -n $6 ]]; then
    PARAMETERS+=" -i \"$6\""
fi

echo "Running: $PARAMETERS"

$PARAMETERS
