target_dir := env_var('HOME')
stow_args := '-t ' + target_dir + ' --no-folding --dotfiles'

[default]
help:
  #!/usr/bin/env bash
  echo "Variables:"
  just --evaluate | sed 's/^/    /'
  echo ""
  just --list

install:
  stow . {{stow_args}}

debug:
  stow . -vn {{stow_args}}

uninstall:
  stow -D --dotfiles -v -t {{target_dir}} .

reload:
  @just uninstall
  @just install

doctor:
  #!/usr/bin/env bash
  missing=0
  for cmd in fd fzf bat starship nvim zsh stow; do
    command -v $cmd &> /dev/null || { echo "✗ $cmd is missing"; ((missing++)); }
  done
  [ $missing -eq 0 ] && echo "✓ All dependencies installed" || exit 1
