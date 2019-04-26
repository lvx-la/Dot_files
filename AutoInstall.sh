#!/bin/sh

VIM_LOOK_FILE="~/.vimrc"
TMUX_LOOK_FILE="~/.tmux.conf"

if [ -f ${VIM_LOOK_FILE} ]; then
  echo "renameing current .vimrc to .old_vimrc"
  mv ~/.vimrc ~/.old_vimrc
fi
if [ -f ${TMUX_LOOK_FILE} ]; then
  echo "renameing current .tmux.conf to .old_tmux.conf"
  mv ~/.tmux.conf ~/.old_tmux.conf
fi

#  echo "put symbolic link .vimrc to ~/ from remote repositoly"
#  ln -s ./.vimrc ~/
#
#  echo "putting symbolic link .tmux.conf to ~/ from remote repositoly"
#  ln -s ./.tmux.conf ~/


  echo "Installing NeoBundle and ColorScheme"

  mkdir -p ~/.vim/bundle
  git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

  mkdir -p ~/.vim/colors
  git clone https://github.com/tomasr/molokai ~/.vim/colors
  cp ~/.vim/colors/colors/molokai.vim ~/.vim/colors

  echo "Installation Completed, Ready to get to start vim"
  echo "Put Symbolic link yourself!!!!!!"
