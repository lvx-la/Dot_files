" setting
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

"コンパイル
nnoremap <F5> :w<CR>:make run<CR>
inoremap <F5> <Esc>:w<CR>:make run<CR>
nnoremap <F6> :w<CR>:! ./run<CR>
inoremap <F6> <Esc>:w<CR>:! ./run<CR>

inoremap ^H ^[ha
inoremap ^L ^[la

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

"マウス系
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
  endif


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list
set listchars=tab:▸-,trail:-
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


"カラースキーム（自作）
colorscheme molokai

" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
set cursorcolumn

autocmd ColorScheme * highlight Comment ctermfg=244 guifg=#888888

autocmd ColorScheme * highlight cursorline cterm=underline ctermfg=NONE guifg=#FF0000
autocmd ColorScheme * highlight cursorcolumn ctermbg=238 guifg=#888888


syntax enable
"バックスペース効かない問題を直す
"set nocompatible iMacでNeoBundleをインストールする際、コメントを外した。
if &compatible
  set nocompatible
endif
set backspace =indent,eol,start 

"#########################################
"キーバインド（自作）
"#########################################
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

"クリップボードを使う
set clipboard =unnamed,autoselect


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

"--------------------------------------------------
" Ocamlの設定
"--------------------------------------------------
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute 'set rtp+=' . g:opamshare . '/merlin/vim'


"NeoBundle
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
"インデントガイダンス"
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
      \ 'winform': 'LightLineWinform',
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

  let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [
    \ 'ruby','javascript','coffee', 'scss', 'html', 'haml', 'slim', 'sh',
      \ 'spec', 'vim', 'zsh', 'sass', 'eruby' ,'ocaml'] }  
  "python
  "let g:syntastic_python_checkers = ['pylint']
  "let g:syntastic_c_checkers = ['clang']

  let g:syntastic_error_symbol='❌'
  let g:syntastic_style_error_symbol = '❌'
  let g:syntastic_warning_symbol = '⚠️'
  let g:syntastic_style_warning_symbol = '⚠️'


 " let g:syntastic_mode_map = {'mode': 'passive'}
 " augroup AutoSyntastic
   "   autocmd!
  "    autocmd InsertLeave,TextChanged * call s:syntastic()
 " augroup END
 " function! s:syntastic()
   "   w
  "    SyntasticCheck
 " endfunction
  
"----------------------------------------------------
"lldb
"---------------------------------------------------
  "NeoBundle 'gilligan/vim-lldb'

"----------------------------------------------------
  "NeoComplete
"---------------------------------------------------
"  if has('lua')
"    "NeoBundle 'Shougo/deoplete.nvim'
"      let g:deoplete#enable_at_startup = 1
"      let g:deoplete#auto_complete_start_length = 2
"      let g:deoplete#max_list = 10000
"      let g:python3_host_prog='/usr/local/bin/python3'
"
"      inoremap <expr><tab> pumvisible() ? "\<C-n>" :
"        \ neosnippet#expandable_or_jumpable() ?
"        \    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"
"
"    "on_i = 1
"    " スニペットの補完機能
"    NeoBundle "Shougo/neosnippet.vim"
"    imap <C-k> <Plug>(neosnippet_expand_or_jump)
"    smap <C-k> <Plug>(neosnippet_expand_or_jump)
"    xmap <C-k> <Plug>(neosnippet_expand_target)
"    if has('conceal')
"      set conceallevel=2 concealcursor=niv
"    endif
"
"    "on_i = 1
"    "on_ft = ['snippet']
"    "depends = ['neosnippet-snippets']
"
"    " スニペット集
"    NeoBundle 'Shougo/neosnippet-snippets'  
"
"    "deopleteに必要な奴ら
"    NeoBundle 'roxma/nvim-yarp'
"    NeoBundle 'roxma/vim-hug-neovim-rpc'
"    "NeoBundle 'Shougo/neco-syntax'
"  endif

" スニペット集

  "ネオコン
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



call neobundle#end()
" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on


