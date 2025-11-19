"--------------------------------------------------
" 基礎系
"--------------------------------------------------
"{{{
"文字コードをUFT-8に設定
set fenc=utf-8
scriptencoding utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" --MODE-- の表示をオフにする
set noshowmode
"クリップボードを使うよん
set clipboard =unnamed,autoselect


" 見た目系
" 行番号を表示
set number

"くらい色に合わせた配色にする"
set background=dark
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list
set listchars=tab:▸-,trail:-,eol:↵
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=4

" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>


"バックスペース効かない問題を直す
"set nocompatible iMacでNeoBundleをインストールする際、コメントを外した。
if &compatible
  set nocompatible
endif
set backspace =indent,eol,start 

"}}}

"--------------------------------------------------
"折りたたみ
"--------------------------------------------------
au FileType vim setlocal foldmethod=marker
au FileType c setlocal foldmethod=indent
au FileType python setlocal foldmethod=indent


"--------------------------------------------------
"コンパイル
"--------------------------------------------------
nnoremap <F5> :w<CR>:make %:r<CR>
inoremap <F5> <Esc>:w<CR>:make %:r<CR>
nnoremap <F6> :w<CR>:! ./%:r<CR>
inoremap <F6> <Esc>:w<CR>:! ./%:r<CR>

inoremap ^H ^[ha
inoremap ^L ^[la


"--------------------------------------------------
"カラースキーム
"--------------------------------------------------

"{{{
colorscheme molokai

" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
set cursorcolumn

"--------------------------------------------------
"カラースキームが気にくわなかったから色変更
"--------------------------------------------------
autocmd ColorScheme * highlight NonText ctermfg=0
autocmd ColorScheme * highlight SpecialKey ctermfg=236
autocmd ColorScheme * highlight Comment ctermfg=244 guifg=#888888
autocmd ColorScheme * highlight cursorline cterm=underline ctermfg=NONE guifg=#FF0000
autocmd ColorScheme * highlight cursorcolumn ctermbg=238 guifg=#888888
autocmd ColorScheme * highlight Variable ctermfg=252


syntax enable
"}}}



"--------------------------------------------------
"キーバインド（自作）
"--------------------------------------------------

"{{{

"補完をJとKに逃す
"inoremap <C-p> <C-k>
"inoremap <C-n> <C-j>
"インサートモードの時のキーバインドをことえりのキーバインドにする
"inoremap <C-p> <Esc>ki
"inoremap <C-n> <Esc>ji
inoremap <C-f> <Esc>lli
inoremap <C-b> <Esc>i
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
nnoremap <F10> :terminal ++curwin <CR>

"}}}


"--------------------------------------------------
"雑なスクリプト的な マウスと、ペーストしたときインデントしないやつあるよ
"--------------------------------------------------

"{{{
"マウス系


"if has('mouse')
"  set mouse=a
"  if has('mouse_sgr')
"      set ttymouse=sgr
"  elseif v:version > 703 || v:version is 703 && has('patch632')
"      set ttymouse=sgr
"  else
"      set ttymouse=xterm2
"  endif
"endif


"ペースとしたときインデントさせないやつ
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
      set paste
      return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
"}}}

"--------------------------------------------------
" Ocamlの設定
"--------------------------------------------------
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute 'set rtp+=' . g:opamshare . '/merlin/vim'


"--------------------------------------------------
" Color_Coded
"--------------------------------------------------
set runtimepath+=/Users/yuki-macbookpro/.vim/bundle/color_coded


"--------------------------------------------------
" SyntaxInfo
"--------------------------------------------------
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()

"--------------------------------------------------
"NeoBundle
"--------------------------------------------------
"{{{


"--------------------------------------------------
" テンプレート
"--------------------------------------------------
autocmd BufNewFile *.c 0r $HOME/.vim/template/c.txt

"#################################################
" インストールするプラグインをここに記述
"#################################################


"--------------------------------------------------
" かっことか自動入力
"--------------------------------------------------

"--------------------------------------------------
"インデントガイダンス ダサい方
"--------------------------------------------------
"NeoBundle 'nathanaelkane/vim-indent-guides'
"  let g:indent_guides_enable_on_vim_startup = 1
"  let g:indent_guides_auto_colors = 0
"  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=white   ctermbg=3
"  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
"  let g:indent_guides_guide_size = 1

"--------------------------------------------------
"OCamlのインデント
"--------------------------------------------------




"--------------------------------------------------
"インデントライン
"--------------------------------------------------

"--------------------------------------------------
"ステータスライン
"--------------------------------------------------

"--------------------------------------------------
"文法チェッカー syntastic
"--------------------------------------------------


let g:color_coded_enabled = 1
let g:color_coded_filetypes = ['c']

" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on


"--------------------------------------------------
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
"--------------------------------------------------
"{{{

if $USER == 'Knight-of-Skyrim'
  let s:opam_share_dir = system("opam config var share")
  let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

  let s:opam_configuration = {}

  function! OpamConfOcpIndent()
    execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
  endfunction
  let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

  function! OpamConfOcpIndex()
    execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
  endfunction
  let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

  function! OpamConfMerlin()
    let l:dir = s:opam_share_dir . "/merlin/vim"
    execute "set rtp+=" . l:dir
  endfunction
  let s:opam_configuration['merlin'] = function('OpamConfMerlin')

  let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
  let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
  let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
  for tool in s:opam_packages
    " Respect package order (merlin should be after ocp-index)
    if count(s:opam_available_tools, tool) > 0
      call s:opam_configuration[tool]()
    endif
  endfor
  " ## end of OPAM user-setup addition for vim / base ## keep this line
  " ## added by OPAM user-setup for vim / ocp-indent ## 849fd5ccb8dd641270409a90ab0ea497 ## you can edit, but keep this line
  if count(s:opam_available_tools,"ocp-indent") == 0
    source "/Users/Knight-of-Skyrim/.opam/default/share/ocp-indent/vim/indent/ocaml.vim"
  endif
  " ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
endif
"}}}
