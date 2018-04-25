" --------------------------------------------
" init.vim 
" --------------------------------------------
let g:python3_host_prog = $PYENV_ROOT . '/shims/python3'
" --------------------------------------------
"  Setting for dein 
" --------------------------------------------

function! s:InitDein()
    " Prepare .config/nvim
    let s:config_dir = $XDG_CONFIG_HOME . "/nvim"
 
    " Prepare .nvim dir
    let s:vimdir = $HOME . "/.nvim"
    if has("vim_starting")
        if ! isdirectory(s:vimdir)
            call system("mkdir " . s:vimdir)
        endif
    endif

    " dein

    " Set dein paths
    let s:dein_dir = s:vimdir . '/dein'
    let s:dein_github = s:dein_dir . '/repos/github.com'
    let s:dein_repo_name = "Shougo/dein.vim"
    let s:dein_repo_dir = s:dein_github . '/' . s:dein_repo_name

    " Check dein has been installed or not
    if !isdirectory(s:dein_repo_dir)
        echo "dein is not installed, install now "
        let s:dein_repo = "https://github.com/" . s:dein_repo_name
        echo "git clone " . s:dein_repo . " " . s:dein_repo_dir
        call system("git clone " . s:dein_repo . " " . s:dein_repo_dir)
    endif
    let &runtimepath = &runtimepath . ',' . s:dein_repo_dir

    "Begin plugin part {{{

    "Check cache
    if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir)

        " 管理するプラグインを記述したファイル
        let s:toml = s:config_dir .  '/dein.toml'
        let s:lazy_toml = s:config_dir . '/dein_lazy.toml'
        call dein#load_toml(s:toml, {'lazy': 0})
        call dein#load_toml(s:lazy_toml, {'lazy': 1})
        :
        call dein#end()
        call dein#save_state()
    endif " dein#load

    if dein#check_install()
        call dein#install()
    endif

    filetype indent plugin on
    syntax on
endfunction

call s:InitDein()

" --------------------------------------------
"  Bacis Setting for Vim 
" --------------------------------------------
" backup
set backup
set backupdir=$HOME/.vim-backup
let &directory = &backupdir
autocmd BufWritePre,FileWritePre,FileAppendPre * call UpdateBackupFile()
function! UpdateBackupFile()
	let basedir = "$HOME/.vim-backup"
	let dir=strftime(basedir."/%Y-%m/%d", localtime())
	if !isdirectory(dir)
		let retval = system("mkdir -p ".dir)
		" 以下のユーザー名とグループは環境に合わせて設定
		" id -p で自分のユーザー名とグループ名は調べられる
		let retval = system("chown yostos:staff ".dir) 
	endif
	exe "set backupdir=".dir
	let time = strftime("%H_%M_%S", localtime())
	exe "set backupext=".time
endfunction
set directory=$HOME/.vim-backup                 "スワップ用のディレクトリを指定

"  ---------------
"  基本的な設定 
"  ---------------
let mapleader = ","
let maplocalleader = "."
" Common Option
if !&compatible
set nocompatible                               "vi互換でなくVimデフォルト設定にする
endif

if has('patch-7.4.1778')
    "set guicolors
endif

if has('termguicolors')
set termguicolors
endif

if has('nvim')
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

syntax enable                                       "シンタックスハイライト

set iminsert=0
set imsearch=0
set list                                        "不可視文字を表示
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲


if has('kaoriya')
highlight CursorIM guibg=Purple guifg=NONE
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
set iminsert=0 imsearch=2
endif
set imdisable                                   " 元は noimdisable
set ruler                                       "右下に行・列番号を表示
set cmdheight=2                                 "コマンドラインに使われる行数
set showcmd                                     "入力中のコマンドをステータスに表示する
set title                                       "タイトルをウィンドウ枠に表示する
set scrolloff=2                                 "スクロールするとき下が見えるように
set laststatus=2                                "エディタウィンドウに２行目にステータスラインを常時表示
set showtabline=2
" Tab
set tabstop=4                                   "タブは4スペース
set shiftwidth=4                                "自動インデントのスペース指定
set smarttab                                    "新しい行を作った時高度なインデントを行う
set expandtab                                   "タブのかわりに空白を使う
set softtabstop=4
set autoindent                                  "新しい行のインデントを現在行と同じにする

" Edit
set smartindent
set showmatch                                   "閉じカッコが入力時対応するカッコを強調
set matchtime=3                                 "対応括弧表示を3秒に
set backspace=indent,eol,start                  "バックスペースで各種消せるよう
set virtualedit+=block                          "文字がない行末にも移動することができる
set modeline                                    "モードラインをオンにする
set modelines=5                                 "5行までモードラインを検索する
" Search
set ignorecase                                  "検索時大文字小文字を区別しない
set smartcase                                   "大文字を含めた検索はその通りに検索する
set incsearch                                   "インクリメンタルサーチを行う
set wrapscan                                    "循環検索オン
set infercase                                   "補完の際大文字小文字を区別しない
nnoremap <silent> <ESC> <ESC>:noh<CR>
set hlsearch                                    "検索結果をハイライト表示する



"現在の日時を入力
imap <silent> <C-d><C-d> <C-r>=strftime("%Y-%m-%d %H:%M")<CR>
nmap <silent> <C-d><C-d> <ESC>i<C-r>=strftime("%Y-%m-%d %H:%M")<CR><CR><ESC>

"
"バックスラッシュやクエッションを状況に応じて自動的にエスケープする
" http://lambdalisue.hatenablog.com/entry/2013/06/23/071344
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() =- '?' ? '\?' : '?'

" Other
set wildmenu                                    "ナビゲーションバーを有効に
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so
let g:python_highlight_all=1
set tw=0                                        "自動改行オフ
set whichwrap=b,s,h,l,<,>,[,]                    "カーソル行を行頭、行末で止まらないように
set cursorline                                  "カーソル行をハイライト
set clipboard=unnamed                           "クリップボードをWindowsと連携する
set hidden                                      "変更中のでも保存せずで他のファイルを表示
set number                                      "行番号を表示する
set switchbuf=useopen                           "新しく開く代りイに既に開いているバッファを
set vb t_vb=                                    "ビープ音を消す
set novisualbell
set nostartofline                               "移動コマンドを使った時行頭に移動しない
set matchpairs& matchpairs+=<:>                 "<>を対応括弧ペアに
set shiftround                                  "インデントをshiftwidthの倍数に
set wrap                                        "ウィンドウより長い行は折り畳む
set colorcolumn=80                              " 80文字目にラインを入れる
set textwidth=0                                 "テキストの最大幅を無効に
set history=10000                               "コマンド、検索の履歴を１万個まで
set mouse=a                                     "マウスモード有効
inoremap jj <ESC>                               "入力モード中に素早くjjと入力した時はESC
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
" grep検索を設定する
set grepformat=%f:%l::%m,%f:%l%m,%f\ \ %l%m,%f
set grepprg=grep\ -hn

" Vim を立ち上げたと時に、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1


" --------------------------------------------
"  Setting for JpFormat 
" --------------------------------------------
" 日本語の行の連結時には空白を入力しない。(jオプションはvim 7.4以降のみ有効)
set formatoptions+=mMj
"au BufRead,BufNewFile *.howm JpSetAutoFormat
"au BufRead,BufNewFile *.howm let b:JpFormatExclude = '^[-+.*=|>";/[[:space:]]'

" 現在行を整形
nnoremap <silent> gl :JpFormat<CR>
vnoremap <silent> gl :JpFormat<CR>


" 自動整形のON/OFF切替
" 30gC の様にカウント指定すると、現バッファのみ折り返し文字数を指定されたカウントに変更します。
nnoremap <silent> gC :JpFormatToggle<CR>

" 現バッファを整形
nnoremap <silent> g,rJ :JpFormatAll<CR>

" 原稿枚数カウント
nnoremap <silent> g,rc :JpCountPages!<CR>

" カーソル位置の分割行をまとめてヤンク
nnoremap <silent> gY :JpYank<CR>
vnoremap <silent> gY :JpYank<CR>
" カーソル位置の分割行をまとめて連結
nnoremap <silent> gJ :JpJoin<CR>
vnoremap <silent> gJ :JpJoin<CR>
" -------------------------------------------------------------------------
" End of init.vim 
" -------------------------------------------------------------------------
"
set printoptions=number:y,header:2,syntax:y,left:5pt,right:5,top:10pt,bottom:10pt
set printfont=MyricaM_M:h12
set printmbfont=r:MyricaM_M:h12,a:yes

