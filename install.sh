#! /usr/bin/env bash

set -e

# Initialize an empty options string
OPTIONS=""

while getopts "du" opt; do
  case $opt in
  d)
    # Verbose and dry-run for debugging
    OPTIONS="-vn"
    ;;
  u)
    # Unstow dotfiles verbosely
    stow -D --dotfiles -v -t "${HOME}" .
    exit 0
    ;;
  \?)
    echo "Invalid option: -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

stow . "${OPTIONS}" \
  -t "${HOME}" \
  --no-folding --dotfiles
