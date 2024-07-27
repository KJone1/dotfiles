#!/usr/bin/env bash

# Description: a script that used with lf file manager to delete files in the cowsay way
# Usage: change the code inside your lfrc delete function to "/home/cowDelete.sh $fx", change the /home/cowDelete.sh to the path of this file
# Inspired from:
# https://github.com/GrenicMars/dotfiles/blob/master/myScript/lf/cowDelete.sh

lightBlue='\033[1;34m'
lightPurple='\033[1;35m'
bold=$(tput bold)
animal="small"

while getopts "th" opt; do
  case $opt in
    t)
      trash_flag=true
      ;;
    h)
      echo "Usage: $0 [-t] file1 file2 ..."
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [[ $OPTIND -gt 1 ]]; then
  shift $((OPTIND-1))
fi

if [ $# -eq 0 ]; then
  echo "No files specified." >&2
  exit 1
fi

process_file() {
  file="$1"
  fileName=$(basename "$file")

  if [ -d "$file" ]; then
    echo -e "  $fileName "
  else
    case "${fileName##*.}" in
      sh) echo -e " $fileName " ;;
      png|jpg|JPG) echo -e "  $fileName " ;;
      svg) echo -e "󰜡  $fileName " ;;
      pdf) echo -e "  $fileName " ;;
      zip|tar|gz|gzip|7z|rar) echo -e " $fileName " ;;
      *) echo -e "  $fileName " ;;
    esac
  fi
}

echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n${lightPurple}"
for file in "$@"; do
  process_file "$file"
done | cowsay -f "$animal" -n

echo -e "${lightBlue}"
if [[ $trash_flag ]]; then
  read -rp "${bold}Move files to trash?[y/n]: " ans
  if [ "$ans" = "y" ]; then
    mkdir -p ~/.trash
    for file in "$@"; do
      mv "$file" ~/.trash
    done
  fi
else
  read -rp "${bold}So you wanna delete them?[y/n]: " ans
  if [ "$ans" = "y" ]; then
    for file in "$@"; do
      rm -rf "$file"
    done
  fi
fi
clear
exit 0
