#!/usr/bin/env bash
# devContainer 作成後の一度きりのセットアップ。
# AutoInstall.sh は「dotfile の symlink」だけを行う（ツールは Dockerfile で導入済み）。
set -euo pipefail

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

# dotfiles をリンク（.vimrc / .tmux.conf / .zshrc / .claude/*）
bash "${WORKSPACE}/AutoInstall.sh"

# コンテナ用の ~/.zshrc.local（mise 有効化 + syntax-highlighting）で上書き。
# AutoInstall がテンプレ(コメントのみ)を置くので、その後に差し替える。
cp "${WORKSPACE}/.devcontainer/zshrc.local" "${HOME}/.zshrc.local"

echo "postCreate done. open a new zsh terminal to load mise & highlighting."
