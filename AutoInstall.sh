#!/bin/sh


VIM_LOOK_FILE="~/.vimrc"
TMUX_LOOK_FILE="~/.tmux.conf"
ZSH_LOCK_FILE="~/.zshrc"
SCRIPT_DIR=$(cd $(dirname $0); pwd)

cd $HOME

  echo "-------------------------------------------------"
  echo -e '\e[33m locking current .vimc .tmux.conf .zshrc \e[m'

if [ -f ${VIM_LOOK_FILE} ]; then
  #echo "renameing current .vimrc to .old_vimrc"
  echo -e '\e[33m renameing current .vimrc to .old_vimrc \e[m'
  mv $HOME/.vimrc $HOME/.old_vimrc
fi
if [ -f ${TMUX_LOOK_FILE} ]; then
  echo "renameing current .tmux.conf to .old_tmux.conf"
  mv $HOME/.tmux.conf $HOME/.old_tmux.conf
fi
if [ -f ${ZSH_LOCK_FILE} ]; then
  echo "renameing current .zshrc to .old_zshrc"
  mv $HOME/.zshrc $HOME/.old_zshrc
fi


  #echo -e '\e[33m \e[m'
  echo "-------------------------------------------------"
  echo -e '\e[33m Installing NeoBundle and ColorScheme \e[m'
  #echo "Installing NeoBundle and ColorScheme"

  mkdir -p $HOME/.vim/bundle
  git clone git://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim

  mkdir -p $HOME/.vim/colors
  git clone https://github.com/tomasr/molokai $HOME/.vim/colors
  cp $HOME/.vim/colors/colors/molokai.vim $HOME/.vim/colors


  ln -s $SCRIPT_DIR/.vimrc $HOME/.vimrc
  ln -s $SCRIPT_DIR/.tmux.conf $HOME/.tmux.conf
  ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc

  echo "-------------------------------------------------"
  echo "Installation Completed, Ready to get to start shell life"
  ls -la $HOME
