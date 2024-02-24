#! /bin/bash

set -e

stow . -t $HOME --ignore=install.sh
