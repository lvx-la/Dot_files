#!/bin/sh

LOOK_FILE="~/.vimrc"
if [-f ${LOOK_FILE} ]; then
  echo "renameing current .vimrc to .oldvimrc"
  mv ~/.vimrc ~/.oldvimrc
fi

  echo "copying .vimrc from remote repositoly to ~/"
  cp ./vimrc ~/
