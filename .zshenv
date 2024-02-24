# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# If you come from bash you might have to change your $PATH.
# Keep entries in path array unique
typeset -aU path
path=($HOME/.local/bin
      $HOME/.local/bin/go/bin/
      /var/lib/k0s/bin
      /opt
      $path)
export PATH
export KUBECONFIG="$HOME/.kube/config"
# Set grim/grimshot screenshot output location
export XDG_SCREENSHOTS_DIR="$HOME/Pictures/screenshots"
# K9S defualt editor
export EDITOR=nvim
export K9S_EDITOR=nvim

