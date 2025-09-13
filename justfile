ignore_files := '--ignore=install.sh --ignore=assets --ignore=.editorconfig'
target_dir := env_var('HOME')
stow_args := '-t ' + target_dir + ' ' + ignore_files + ' --no-folding --dotfiles'

default:
  @just --choose

install:
  stow . {{stow_args}}

debug:
  stow . -vn {{stow_args}}

uninstall:
  stow -D --dotfiles -v -t {{target_dir}} .
