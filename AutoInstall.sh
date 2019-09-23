#!/bin/sh


VIM_LOOK_FILE="~/.vimrc"
TMUX_LOOK_FILE="~/.tmux.conf"

cd $HOME

if [ -f ${VIM_LOOK_FILE} ]; then
  #echo "renameing current .vimrc to .old_vimrc"
  echo -e '\e[33m renameing current .vimrc to .old_vimrc \e[m'
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


  #echo -e '\e[33m \e[m'
  echo "-------------------------------------------------"
  echo -e '\e[33m Installing NeoBundle and ColorScheme \e[m'
  #echo "Installing NeoBundle and ColorScheme"

  mkdir -p $HOME/.vim/bundle
  git clone git://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim

  mkdir -p $HOME/.vim/colors
  git clone https://github.com/tomasr/molokai $HOME/.vim/colors
  cp $HOME/.vim/colors/colors/molokai.vim $HOME/.vim/colors

  SCRIPT_DIR=$(cd $(dirname $0); pwd)

  ln -s $SCRIPT_DIR/.vimrc $HOME/.vimrc
  ln -s $SCRIPT_DIR/.tmux.conf $HOME/.tmux.conf

  echo "-------------------------------------------------"
  echo "Installation Completed, Ready to get to start vim"
  echo "Put Symbolic link yourself!!!!!!"
