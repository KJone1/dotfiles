#! /bin/bash

set -e

# Initialize an empty options string
OPTIONS=""

while getopts "d" opt; do
  case $opt in
    d)
      # If the -d (debug) flag is present, pass -n to stow
      OPTIONS="-n"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

stow . -vv $OPTIONS -t $HOME --ignore=install.sh --ignore=assets

