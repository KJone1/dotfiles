#!/usr/bin/env bash

update_count=$(( $(dnf check-update | grep -cE ' updates$') ))  # Count or set to 0

if [ "$update_count" -gt 0 ]; then
  echo "$update_count"
fi

