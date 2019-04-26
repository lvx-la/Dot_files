#!/bin/bash

if [-f ${~/.vimrc} ]; then
  echo "renameing current .vimrc to .oldvimrc"
  mv ~/.vimrc ~/.oldvimrc
fi

  echo "copying .vimrc from remote repositoly to ~/"
  cp ./vimrc ~/
