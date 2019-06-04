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
"クリップボードを使う
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
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2

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

"#########################################
"カラースキームが気にくわなかったから色変更
"#########################################
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

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

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
NeoBundle 'cohama/lexima.vim'

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

NeoBundle 'let-def/ocp-indent-vim'



"--------------------------------------------------
"インデントライン
"--------------------------------------------------
NeoBundle 'Yggdroot/indentLine'
  let g:indentLine_color_term = 244 
  let g:indentLine_char = '┆'

"--------------------------------------------------
"ステータスライン
"--------------------------------------------------
"
"{{{
NeoBundle 'itchyny/lightline.vim'
      
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:lightline = {
      \'active':{
      \ 'left':[['mode','paste'], ['fugitive','branch','readonly','filepath','modified']],
      \ 'right':[
      \ [ 'syntastic', 'lineinfo' ],
      \ [ 'percent' ], [ 'winform' ], 
      \ [ 'fileformat','fileencoding','filetype' ]
      \ ]
      \ },
      \
      \'component_function':{
      \ 'filepath':'FilePath',
      \ 'fugitive':'LightLineFugitive',
      \ 'fileformat': 'LightLineFileformat',
      \ 'fileencoding': 'LightLineFileencoding',
      \ 'filetype': 'LightLineFiletype'
      \},
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \   'warning':'#warningmsg#'
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \   'warning':'error'
      \ }
      \}

"""\ 'winform': 'LightLineWinform',
let g:lightline.component = {
    \ 'lineinfo': '%3l[%L]:%-2v'}

function! LightLineWinform()
  return winwidth(0) > 88 ? 'w' . winwidth(0) . ':' . 'h' . winheight(0) : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 80 ? &fileformat : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 60 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! FilePath()
  if winwidth(0) > 30
    return expand("%:s")
  else
    return expand("%:t")
  endif
endfunction


function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction


function! LightLineFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && winwidth(0) > 55
      let _ = fugitive#head()
      return strlen(_) ? '⥬ '._ : ''
    endif
  catch
  endtry
  return ''
endfunction



augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END

"}}}

"--------------------------------------------------
"文法チェッカー
"--------------------------------------------------
NeoBundle 'scrooloose/syntastic'
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_enable_signs=1


  let g:syntastic_ocaml_checkers = ['merlin'] 
  let g:syntastic_python_checkers = ['pylint']
  "let g:syntastic_c_checkers = ['clang']

  let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [
    \ 'ruby','javascript','coffee', 'scss', 'html', 'haml', 'slim', 'sh',
      \ 'spec', 'vim', 'zsh', 'sass', 'eruby' ,'ocaml'] }  
  "python

  let g:syntastic_error_symbol= '×'
  let g:syntastic_style_error_symbol = '×'
  let g:syntastic_warning_symbol = '∆'
  let g:syntastic_style_warning_symbol = '∆'


  
"----------------------------------------------------
"lldb
"---------------------------------------------------
  "NeoBundle 'gilligan/vim-lldb'

"----------------------------------------------------
  "ネオコン
"----------------------------------------------------

  NeoBundle 'Shougo/NeoComplete'
    let g:neocomplete#enable_at_startup = 1
    " 大文字が入力されるまで大文字小文字の区別をなくす
    let g:neocomplete#enable_smart_case = 1
    "3文字以上の単語に対して保管を有効にする
    let g:neocomplete#min_keyword_length = 3
    let g:neocomplete#max_list = 20
    
    let g:neocomplete#auto_completion_start_length = 1
    inoremap <expr> <C-h>
      \ neocomplete#smart_close_popup()


  NeoBundle 'Shougo/neosnippet-snippets'  
  NeoBundle 'Shougo/neosnippet.vim'


  NeoBundle 'Shougo/neco-syntax'
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)
  " SuperTab like snippets behavior.
    imap  <expr><TAB>
          \ neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
       
    smap <expr><TAB> 
          \ neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
       
      if has('conceal')
        set conceallevel=2 concealcursor=i
      endif

"--------------------------------------------------
"FileTree
"--------------------------------------------------
  NeoBundle 'scrooloose/nerdtree'
  nnoremap <C-e> :NERDTreeToggle<CR>

"----------------------------------------------------
"git
"---------------------------------------------------
  NeoBundle 'tpope/vim-fugitive'
  set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

"--------------------------------------------------
"HTML&CSS
"--------------------------------------------------
NeoBundleLazy 'mattn/emmet-vim',{
      \'autoload':{'filetypes':['html']}
      \}

NeoBundleLazy 'vim-css3-syntax',{
      \'autoload':{'filetypes':['css']}
      \}

"NeoBundleLazy 'pangloss/vim-javascript',{
      \'autoload':{'filetypes':['js']}
      \}

"NeoBundleLazy 'othree/html5.vim',{
"      \'autoload':{'filetypes':['html']}
"      \}
"
"--------------------------------------------------
"color
"--------------------------------------------------
"  NeoBundleLazy 'jeaye/color_coded', {
"    \ 'build': {
"      \   'unix': 'rm -f CMakeCache.txt && cmake . && make && make install',
"    \ },
"    \ 'autoload': { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] },
"    \ 'build_commands' : ['cmake', 'make']
"  \}
"

call neobundle#end()

"}}}


let g:color_coded_enabled = 1
let g:color_coded_filetypes = ['c']

" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on


