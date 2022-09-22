#--------------------------------------------------------
#Aliases
#--------------------------------------------------------
case ${USER} in
  yu2ki)
    alias cat='lolcat'
    alias tree='tree -NC'
    alias ll='ls -lah'
    alias :q='exit'
    ;;
  Knight-of-Skyrim)
    alias tree='tree -NC'
esac

echo "Wellcome" ${USER}

#--------------------------------------------------------
#色
#--------------------------------------------------------
autoload -Uz colors

alias ls='ls -FG'
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS=gxfxcxdxbxegedabagacad

colors

#--------------------------------------------------------
#プロンプト
#--------------------------------------------------------

#プロンプトに表示する情報
PROMPT='%F{green}%n%f %~ > '


#--------------------------------------------------------
#gitのブランチ名をプロンプトの右側に表示する
#--------------------------------------------------------
#
# ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}!(no branch)"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status="%F{blue}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}[$branch_name]"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプトの右側(RPROMPT)にメソッドの結果を表示させる
RPROMPT='`rprompt-git-current-branch`'

#--------------------------------------------------------
#autocomplete
#--------------------------------------------------------
autoload -U compinit
compinit

#--------------------------------------------------------
#path to develop apps
#--------------------------------------------------------

#--------------------------------------------------------
#おまじない
#--------------------------------------------------------
#Must write on end of .zshrc
tmux ls
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias python="python3"
