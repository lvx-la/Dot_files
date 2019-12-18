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

alias getHomesignal='curl -X GET "https://api.nature.global/1/appliances" -H "accept: application/json" -k --header "Authorization: Bearer 5DF4W4jxkZA3Tpc7Gh26s_d51qjOoGTQZfZkXpn2XU8.U7VB7ux95CN9iSoLMeGnS0nRNz_vBB7ONpRm1OMz94o"|jq .'

case ${USER} in
  yuki-macbookpro)
    alias neco='lolcat'
    alias cat='lolcat -n'
    alias connect-u='sh ~/Desktop/ConnectUbuntu.sh'
    alias l~='ls -a ~/'
    alias tree='tree -NC'
    alias ll='ls -lah'
    alias :q='exit'
    ;;
  Knight-of-Skyrim)
    alias tree='tree -NC'
esac

case ${USER} in
  yuki-macbookpro)
    function cdts(){
      cd /Users/yuki-macbookpro/Documents/大学/Third_Grade/Spring
    }
    function cdtf(){
      cd /Users/yuki-macbookpro/Documents/大学/Third_Grade/Fall
    };;
  Knight-of-Skyrim)
    function cdts(){
      cd /Users/Knight-of-Skyrim/Documents/東洋大学/3年生/Spring
    };;
esac


#--------------------------------------------------------
#色
#--------------------------------------------------------
autoload -Uz colors

alias ls='ls -FG'
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS=gxfxcxdxbxegedabagacad

colors

#--------------------------------------------------------
#gitのブランチ名をプロンプトの右側に表示する
#--------------------------------------------------------
#
# ブランチ名を色付きで表示させる関数
function rprompt-git-current-branch {
  local st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="   "
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="\e[38;5;2m\e[0m\e[48;5;2mU "
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="\e[38;5;3m\e[0m\e[48;5;3mM "
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="\e[38;5;5m\e[0m\e[48;5;5m! "
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "\e[38;5;1m\e[0m\e[48;5;1m Conflict  \e[0m"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status=""
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}$branch_name\e[0m"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプトの右側(RPROMPT)にメソッドの結果を表示させる
#RPROMPT='`rprompt-git-current-branch`[%F{white}%~%F{cyan}]'
RPORMPT=' '

#--------------------------------------------------------
#プロンプト
#--------------------------------------------------------
function numberOfHistory {
    history | tail -n 1 | awk '{printf ($1+1)}'
}

function thdirs {
    echo $PWD | awk -F '/' '{for(i=(NF-2);i<NF;++i){printf("%s/",$i)}print $NF}'
}


#TODO 書き方アホみたいに汚い 上の関数利用しろや
#2バイト文字(Nardfontだけかも)をトイレに投げるとバグる
#プロンプトに2バイト文字入っている時は右に張り付いて、そうでない時は右2文字開くようになっている。
function hypen {
    local hendoustr hendoustr1 hendoustr2 hendoustr3 hendouLength numberOfHyphens hypens
    hendoustr=`history | tail -n 1 | awk '{printf ($1+1)}'`
    hendoustr1=`echo "$USER"`
    hendoustr2=`echo $PWD | awk -F '/' '{for(i=(NF-2);i<NF;++i){printf("%s/",$i)}print $NF}'`
    #hendoustr3=`rprompt-git-current-branch`
    hendouLength=`echo $hendoustr$hendoustr1$hendoustr2 | wc -m | awk '{print $1}'`

    if [ ! -e  ".git" ]; then
        numberOfDefaultString=15
    else
        nuberOfBranchName=`echo $branch_name | wc -m | awk '{print $1}'`
        numberOfDefaultString=`expr 22 + $nuberOfBranchName`
    fi
    numberOfHyphens=`expr $COLUMNS - \( $hendouLength + $numberOfDefaultString \)`
    hypens=`repeat $numberOfHyphens printf "-"`
    echo $hypens
}

myPreFunc2() {
    printf "\e[38;5;87m-{\e[38;5;11m `numberOfHistory` \e[38;5;87m}---< \e[38;5;2m$USER \e[38;5;87m>\e[m"

    printf "`hypen`" | lolcat

    printf "`rprompt-git-current-branch`\e[38;5;87m[`thdirs`]\n"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd myPreFunc2

#プロンプトに表示する情報
#PROMPT='%F{cyan}-{%F{yellow} %h %F{cyan}}---(%F{white} %* %F{cyan})---<%F{green} %n %F{cyan}>---`hyphen``rprompt-git-current-branch`[%F{white}%C%F{cyan}]
PROMPT='%# %F{default}'


#--------------------------------------------------------
#Path to my bin
#--------------------------------------------------------

case ${USER} in
  yuki-macbookpro*)
    #my bin
    export PATH="/usr/local/bin/mybin:$PATH"
    export CPATH=$CPATH:/Users/yuki-macbookpro/Documents/cs2019_IOT/tcar_sample/Includes
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
    export PATH="/Users/Knight-of-Skyrim/miniconda3/bin:$PATH"
    ;;
esac


#--------------------------------------------------------
#入力した文字から始まるコマンド履歴を検索
#--------------------------------------------------------
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search


#--------------------------------------------------------
#プレコマンド
#--------------------------------------------------------
echo "Wellcome" ${USER} | lolcat
tmux ls

#--------------------------------------------------------
#プラギン読むよ
#--------------------------------------------------------
#Must write on end of .zshrc

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh


