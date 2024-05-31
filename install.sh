#! /bin/bash

set -e

# Initialize an empty options string
OPTIONS=""

while getopts "d" opt; do
  case $opt in
    d)
      # If the -d (debug) flag is present, pass -n to stow
      OPTIONS="--verbose=2 -n"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

stow . $OPTIONS \
  -t $HOME \
  --ignore=install.sh --ignore=assets --ignore=.editorconfig \
  --no-folding --dotfiles
