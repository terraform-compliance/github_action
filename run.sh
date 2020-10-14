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

echo "Total number of lines in the plan (before): $(cat $PLAN_FILE | wc -l)"
echo " ====================== PLAN FILE (before) ========================= "
cat "$PLAN_FILE" | head -n 1
echo " ====================== PLAN FILE (before) ========================= "
cat "$PLAN_FILE" | tail -n 1 > "$PLAN_FILE.tmp" && mv "$PLAN_FILE.tmp" "$PLAN_FILE"
echo "Total number of lines in the plan (after): $(cat $PLAN_FILE | wc -l)"
echo " ====================== PLAN FILE (after) ========================= "
cat $PLAN_FILE
echo " ====================== PLAN FILE (after) ========================= "

echo "Running: $PARAMETERS"
$PARAMETERS
