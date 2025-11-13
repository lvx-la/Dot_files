#!/bin/sh


VIM_FILE="$HOME/.vimrc"
TMUX_FILE="$HOME/.tmux.conf"
ZSH_FILE="$HOME/.zshrc"
SCRIPT_DIR=$(cd $(dirname $0); pwd)

cd $HOME

  echo "-------------------------------------------------"
  echo -e '\e[33m locking current .vimc .tmux.conf .zshrc \e[m'

if [ -f "${VIM_FILE}" ]; then
  echo -e '\e[33m renameing current .vimrc to .old_vimrc \e[m'
  mv "${VIM_FILE}" "$HOME/.old_vimrc"
fi
if [ -f "${TMUX_FILE}" ]; then
  echo "renameing current .tmux.conf to .old_tmux.conf"
  mv "${TMUX_FILE}" "$HOME/.old_tmux.conf"
fi
if [ -f "${ZSH_FILE}" ]; then
  echo "renameing current .zshrc to .old_zshrc"
  mv "${ZSH_FILE}" "$HOME/.old_zshrc"
fi


  # #echo -e '\e[33m \e[m'
  # echo "-------------------------------------------------"
  # echo -e '\e[33m Installing NeoBundle and ColorScheme \e[m'
  # #echo "Installing NeoBundle and ColorScheme"

  # mkdir -p $HOME/.vim/bundle
  # git clone git://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim

  # mkdir -p $HOME/.vim/colors
  # git clone https://github.com/tomasr/molokai $HOME/.vim/colors
  # cp $HOME/.vim/colors/colors/molokai.vim $HOME/.vim/colors


  ln -s $SCRIPT_DIR/.vimrc $HOME/.vimrc
  ln -s $SCRIPT_DIR/.tmux.conf $HOME/.tmux.conf
  ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc

  echo "-------------------------------------------------"
  echo "Installation Completed, Ready to get to start shell life"
  ls -la $HOME
