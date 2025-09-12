ignore_files := '--ignore=install.sh --ignore=assets --ignore=.editorconfig'
stow_args := '-t "${HOME}" ' + ignore_files + ' --no-folding --dotfiles'

default:
  @just --choose

install:
  stow . {{stow_args}}

debug:
  stow . -vn {{stow_args}}

uninstall:
  stow -D --dotfiles -v -t "${HOME}" .
