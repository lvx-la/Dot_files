#!/bin/sh

LOOK_FILE="~/.vimrc"

if [ -f ${LOOK_FILE} ]; then
  echo "renameing current .vimrc to .oldvimrc"
  mv ~/.vimrc ~/.oldvimrc
fi

  echo "copying .vimrc from remote repositoly to ~/"
  cp ./.vimrc ~/
  echo "Complete to copy ./.vimrc to ~/.vimrc"
  echo "Installing NeoBundle and ColorScheme"

  mkdir -p ~/.vim/bundle
  git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

  mkdir -p ~/.vim/colors
  git clone https://github.com/tomasr/molokai ~/.vim/colors
  cp ~/.vim/colors/colors/molokai.vim ~/.vim/colors

  echo "Installation Completed, Ready to get to start vim"
  vim ~/.vimrc
