# USER INPUT
fpath=(~/.zsh/completion $fpath)

#if [ "$(uname)" == 'Darwin' ]; then
#  OS='Mac'
#elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
#  OS='Linux'
#elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then                                                                                           
#  OS='Cygwin'
#else
#  echo "Your platform ($(uname -a)) is not supported."
#  exit 1
#fi
#
##Auto Install Homebrew (Garbage Code)
#if [ type "brew" > /dev/null 2>&1 ]; then
#elif [ $OS='Mac' ]; then
#  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#fi

#Ctrl-Dで終了させない
setopt ignoreeof
setopt nonomatch


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

case ${USER} in
  yuki-macbookpro)
    alias neco='lolcat'
    alias cat='lolcat -n'
    alias connect-u='sh ~/Desktop/ConnectUbuntu.sh'
    alias l~='ls -a ~/'
    alias tree='tree -NC'
    ;;
  Knight-of-Skyrim)
    alias t='tree';;
esac

case ${USER} in
  yuki-macbookpro)
    function cdts(){
      cd /Users/yuki-macbookpro/Documents/大学/Third_Grade/Spring
    };;
  Knight-of-Skyrim)
    function cdts(){
      cd /Users/Knight-of-Skyrim/Documents/東洋大学/3年生/Spring
    };;
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
#Path to my bin
#--------------------------------------------------------

case ${USER} in
  yuki-macbookpro*)
    #my bin
    export PATH="/usr/local/bin/mybin:$PATH"
    ;;
  Knight-of-Skyrim*)
    export PATH="/usr/local/bin:$PATH"
    ;;
esac


#--------------------------------------------------------
#path to develop apps
#--------------------------------------------------------

case ${USER} in
  yuki-macbookpro*)
    # added by Miniconda3 4.3.21 installer
    export PATH="/Users/yuki-macbookpro/miniconda3/bin:$PATH"
    # opam configuration
    test -r /Users/yuki-macbookpro/.opam/opam-init/init.zsh && . /Users/yuki-macbookpro/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
    ;;
  Knight-of-Skyrim*)
    export PATH="/usr/local/bin:$PATH"
    ;;
esac



#--------------------------------------------------------
#おまじない
#--------------------------------------------------------
#Must write on end of .zshrc
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


