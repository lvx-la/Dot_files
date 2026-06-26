# 汎用 devContainer ベース。非root の vscode ユーザ付き公式イメージを使う。
ARG VARIANT=ubuntu-24.04
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

COPY cacertCustom.crt /usr/local/share/ca-certificates/cacertCustom.crt
RUN sudo update-ca-certificates

# 開発ツールを焼き込み（.zshrc が依存: zsh/tmux/jq/whiptail/git、+ vim/less 等）
RUN sudo apt update \
 && sudo apt upgrade -y \ 
 && export DEBIAN_FRONTEND=noninteractive \
 && sudo apt install -y --no-install-recommends \
    zsh tmux vim less jq whiptail tree \
    curl wget ca-certificates unzip git \
    build-essential locales \
    zsh-syntax-highlighting \
    openssh-server \
    gh \
 && rm -rf /var/lib/apt/lists/*

# AWS CLI v2（.zshrc / mise.toml のタスクが aws を使う）
RUN ARCH=$(uname -m) \
 && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o /tmp/awscliv2.zip \
 && unzip -q /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip

RUN chsh -s /usr/bin/zsh vscode \
 && mkdir -p /home/vscode/.claude \
 && chown vscode:vscode /home/vscode/.claude

USER vscode
RUN curl -fsSL https://mise.run | sh
RUN curl -fsSL https://claude.ai/install.sh | bash
USER root

RUN mkdir -p /home/vscode/workspace

