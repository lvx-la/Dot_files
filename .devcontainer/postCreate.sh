#!/usr/bin/env bash
set -euo pipefail

# dotfiles をリンク（.vimrc / .tmux.conf / .zshrc / .claude/*）
mkdir -p $HOME/Dot_files
git clone https://github.com/lvx-la/Dot_files.git $HOME/Dot_files
bash "${HOME}/Dot_files/AutoInstall.sh"

# sudo /usr/sbin/sshd

echo "postCreate done."
