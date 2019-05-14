# USER INPUT
fpath=(~/.zsh/completion $fpath)

#Ctrl-Dで終了させない
setopt ignoreeof


# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' max-errors 3
zstyle :compinstall filename '/Users/yuki-macbookpro/.zshrc'

autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=1
# End of lines added by compinstall

#--------------------------------------------------------
#Aliases
#--------------------------------------------------------
alias neco='cat'
alias cat='cat -n|lolcat'
alias connect-u='sh ~/Desktop/ConnectUbuntu.sh'
alias l~='ls -a ~/'

#--------------------------------------------------------
#色
#--------------------------------------------------------
autoload -Uz colors

alias ls='ls -FG'
export LSCOLORS=gxfxcxdxbxegedabagacad

colors

#--------------------------------------------------------
#プロンプト
#--------------------------------------------------------

#プロンプトに表示する情報
PROMPT='%F{green}%n%f %~ > '

function cdts(){
  cd /Users/yuki-macbookpro/Documents/大学/Third_Grade/Spring
}

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
#PATH
#--------------------------------------------------------
# opam configuration
test -r /Users/yuki-macbookpro/.opam/opam-init/init.zsh && . /Users/yuki-macbookpro/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# added by Miniconda3 4.3.21 installer
export PATH="/Users/yuki-macbookpro/miniconda3/bin:$PATH"


#--------------------------------------------------------
#おまじない
#--------------------------------------------------------
#Must write on end of .zshrc
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


