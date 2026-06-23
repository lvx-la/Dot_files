# 汎用 devContainer ベース。非root の vscode ユーザ付き公式イメージを使う。
ARG VARIANT=ubuntu-24.04
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

# 開発ツールを焼き込み（.zshrc が依存: zsh/tmux/jq/whiptail/git、+ vim/less 等）
RUN apt-get update \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install -y --no-install-recommends \
    zsh tmux vim less jq whiptail tree \
    curl wget ca-certificates unzip git \
    build-essential locales \
    zsh-syntax-highlighting \
 && rm -rf /var/lib/apt/lists/*

# AWS CLI v2（.zshrc / mise.toml のタスクが aws を使う）
RUN ARCH=$(uname -m) \
 && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o /tmp/awscliv2.zip \
 && unzip -q /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip

# 既定シェルを zsh に。
# ~/.claude は vscode 所有で先に作る → 名前付き Volume 初回マウント時に所有権を継承させ、
# root 所有になって書き込めなくなる devcontainer の定番ハマりを回避する。
RUN chsh -s /usr/bin/zsh vscode \
 && mkdir -p /home/vscode/.claude \
 && chown vscode:vscode /home/vscode/.claude

# mise と Claude Code を vscode ユーザのホームに入れる（~/.local/bin/ 配下）
USER vscode
RUN curl -fsSL https://mise.run | sh
RUN curl -fsSL https://claude.ai/install.sh | bash
USER root
