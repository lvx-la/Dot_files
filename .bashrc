#初回シェル時のみTmuxを実行
if [ $SHLVL = 1 ]; then
  tmux
fi

if [ $SHLVL = 2 ]; then
  neofetch
  echo "----------------------------------  Logged in ----------------------------------"
fi

function g(){
  "/usr/local/bin/w3m" "https://www.google.co.jp/search?q=$1"  
} 
XDG_CONFIG_HOME=~/.config

function vimos(){
  cd /Users/yuki-macbookpro/Documents/大学/2年/2年秋/cs2018_os/
  vim .
}
function vimnet(){
  cd /Users/yuki-macbookpro/Documents/大学/2年/2年秋/CS2018_NET/
  vim .
}
function vimbe(){
  cd /Users/yuki-macbookpro/Documents/大学/2年/2年秋/CS2018_BE/
  vim .
}
function cdnet(){
  cd /Users/yuki-macbookpro/Documents/大学/2年/2年秋/CS2017_NET/$1回目
}
function cdos(){
  cd /Users/yuki-macbookpro/Documents/大学/2年/2年秋/cs2017_os/$1回目
}
function cdbe(){
  cd /Users/yuki-macbookpro/Documents/大学/2年/2年秋/CS2018_BE/$1回目
}

function cdts(){
  cd /Users/yuki-macbookpro/Documents/大学/Third_Grade/Spring
}

# opam configuration
test -r /Users/yuki-macbookpro/.opam/opam-init/init.sh && . /Users/yuki-macbookpro/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

alias :q=exit

alias ls='ls -FG'
export LSCOLORS=gxfxcxdxbxegedabagacad
