#--------------------------------------------------------
#Aliases
#--------------------------------------------------------
case ${USER} in
  yu2ki)
    # alias cat='lolcat'
    alias tree='tree -NC'
    alias ll='ls -lah'
    alias :q='exit'
    ;;
  Knight-of-Skyrim)
    alias tree='tree -NC'
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
#プロンプト
#--------------------------------------------------------

#プロンプトに表示する情報
PROMPT_INS="%F{blue}[INS]%f "
PROMPT_NOR="%F{green}[NOR]%f "
PROMPT_VIS="%F{yellow}[VIS]%f "

## 初期値
VIM_MODE_PROMPT=$PROMPT_INS
# AWSアカウント番号（末尾4桁）
if [[ -n "$AWS_ACCESS_KEY_ID" || -n "$AWS_PROFILE" ]]; then
    AWS_ACCOUNT_NUM=$(aws sts get-caller-identity | jq -r '.Account' | rev | cut -c 1-4 | rev)
else
    AWS_ACCOUNT_NUM=""
fi
# キャッシュ
cache_aws_access_key=$AWS_ACCESS_KEY_ID
cache_aws_profile=$AWS_PROFILE

function vim-mode {
    if [[ $REGION_ACTIVE -ne 0 ]]; then
        VIM_MODE_PROMPT=$PROMPT_VIS
    elif [[ $KEYMAP = vicmd ]]; then
        VIM_MODE_PROMPT=$PROMPT_NOR
    elif [[ $KEYMAP = main ]]; then
        VIM_MODE_PROMPT=$PROMPT_INS
    fi
}

function zle-line-init {
    # AWS アカウント番号更新
    vim-mode
    if [[ $cache_aws_access_key != $AWS_ACCESS_KEY_ID ]] || [[ $cache_aws_profile != $AWS_PROFILE ]]; then
        AWS_ACCOUNT_NUM=`aws sts get-caller-identity | jq -r '.Account' | rev | cut -c 1-4 | rev`
        cache_aws_access_key=$AWS_ACCESS_KEY_ID
        cache_aws_profile=$AWS_PROFILE
    fi
    PROMPT=$'%F{green}%n [$AWS_ACCOUNT_NUM]%f %~ \n$VIM_MODE_PROMPT >'
    zle reset-prompt
}

function zle-keymap-select {
    vim-mode
    PROMPT=$'%F{green}%n [$AWS_ACCOUNT_NUM]%f %~ \n$VIM_MODE_PROMPT >'
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

bindkey -v # viモードにする
export KEYTIMEOUT=1 # 1msで戻る

#--------------------------------------------------------
#gitのブランチ名をプロンプトの右側に表示する
#--------------------------------------------------------
#
# ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status

  if ! git rev-parse --git-dir > /dev/null 2>&1; then
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
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#--------------------------------------------------------
# tmuxを起動させる
#--------------------------------------------------------

function tmux-sel () {
    #if [[ ! -n $TMUX && $- == *l* ]]; then ログインシェルのみ
    if [[ ! -n $TMUX ]]; then
        # tmuxのセッションIDを取得
        sessions=( $(tmux ls | cut -d':' -f1) )
        if [[ -z "$sessions" ]]; then
            tmux new-session
        fi

        menu_items=()
        for session in "${sessions[@]}"; do
            menu_items+=("$session" "$session")
        done
        # whiptailで選択ダイアログを表示
        selected_session=$(whiptail --notags --title "Session Selector" --cancel-button "--no-tmux" --menu "Choose a tmux session:" 20 60 10 "${menu_items[@]}" "ns" "[Create new session]" 3>&1 1>&2 2>&3)
        if [[ "$selected_session" = "ns" ]]; then
            tmux new-session # 明示的に選択された時のみ起動
        elif [[ -n "$selected_session" ]]; then
            tmux a -t "$selected_session"
        else
            :  # Start terminal without tmux. 
        fi
    else
        echo "Tmux Shell"
    fi
}