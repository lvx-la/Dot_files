#!/bin/sh

LOOK_FILE="~/.vimrc"

if [ -f ${LOOK_FILE} ]; then
  echo "renameing current .vimrc to .oldvimrc"
  mv ~/.vimrc ~/.oldvimrc
fi

  echo "put symbolic link .vimrc to ~/ from remote repositoly"
  ln -s ./.vimrc ~/
  echo "Complete to put symbolic link ./.vimrc to ~/.vimrc"

  echo "putting symbolic link .tmux.conf to ~/ from remote repositoly"
  ln -s ./.tmux.conf ~/
  echo "Complete to put symbolic link ./.tmux.conf to ~/.tmux.conf"


  echo "Installing NeoBundle and ColorScheme"

  mkdir -p ~/.vim/bundle
  git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

  mkdir -p ~/.vim/colors
  git clone https://github.com/tomasr/molokai ~/.vim/colors
  cp ~/.vim/colors/colors/molokai.vim ~/.vim/colors

  echo "Installation Completed, Ready to get to start vim"
  vim ~/.vimrc
