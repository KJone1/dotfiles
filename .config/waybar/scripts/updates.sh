#!/usr/bin/env bash

update_count=$(( $(dnf list updates -q | awk '{ print $2 }' | grep -cE '[0-9]+') ))  # Count or set to 0

if [ "$update_count" -gt 0 ]; then
  echo "$update_count"
fi

