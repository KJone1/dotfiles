#! /bin/bash

set -e

# Initialize an empty options string
OPTIONS=""

while getopts "du" opt; do
  case $opt in
    d)
      OPTIONS="-v -n"  # Verbose and dry-run for debugging
      ;;
    u)
      stow -D --dotfiles -v -t "$HOME" . # Unstow dotfiles verbosely
      exit 0
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
