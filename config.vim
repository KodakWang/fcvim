"
" FCVIM: Advanced VIM.
"
" Copyright (C) 2013-2021 Kodak Wang. All rights reserved.
"
" Created by Kodak Wang <kodakwang@gmail.com>
"
" Please do not reproduced, distribute or quote without written
" permission of the author. This software is not perfect, any
" problems arising from the use, have nothing to do with the author.
"

try
    if exists('g:fcvim_loaded_config') || &compatible
        throw 'already loaded' . expand('<sfile>') . '!!!!'
    endif
catch
    finish
endtry
let g:fcvim_loaded_config = 1

"----------------------------------------------------------------------
" misc.

set shortmess=atl               " 不显示欢迎界面
set number                      " 显示行号

" 状态栏
" if !exists("g:loaded_statline_plugin")
" set ruler                       " 打开状态栏标尺
" set laststatus=2                " 总是显示状态栏
" set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ \ \ \ \ \ \ \ %8(%l,%c%)\ \ \ \ \ \ \ \ %3p%%%)\ 
" endif
set wildmenu                    " 打开状态栏命令行补全提示
set cmdheight=2                 " Height of the command bar

set wildignore=*.o,*.obj        " 打开文件选择忽略编译文件

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" Linebreak on 500 characters
"set linebreak                   " 整词换行
"set textwidth=500
"set wrap                        " 自动换行

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

set nocompatible                " 关闭VI兼容模式
set history=700                 " 历史记录
set magic                       " 正则规划反斜杠
set hidden                      " 允许未保存缓冲区
set mouse=a                     " 鼠标可用

" No annoying sound on errors
set noerrorbells                " 关闭错误信息响铃
set novisualbell                " 关闭使用可视响铃代替呼叫
set vb t_vb=                    " 置空错误铃声的终端代码
set timeoutlen=500              " mapping delay
set ttimeoutlen=500             " key code delay

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Specify the behavior when switching between buffers
" try
    " set switchbuf=useopen,usetab,newtab
    " set stal=2
" catch
    " throw ""
" endtry


set tags=tags;                  " 标签
" set autochdir                   " 自动切换cwd为当前焦点的（部分控件不兼容）
set writebackup                 " 覆盖备份
set backupext=.bak              " 备份文件后缀

" Set to auto read when a file is changed from the outside
set autoread

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Remember info about open buffers on close
set viminfo^=%

" Ignore case when searching 不区分大小写
" set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers 搜索自动跳转
" set incsearch

" 折叠
set foldenable              " 开始折叠
set foldmethod=syntax       " 设置语法折叠
set foldcolumn=0            " 设置折叠区域的宽度
"setlocal foldlevel=1       " 设置折叠层数为
set foldlevel=100           " 关闭自动折叠
"set foldclose=all          " 置为自动关折叠

"----------------------------------------------------------------------
" indent

" if !exists("g:loaded_linuxsty")
" set expandtab       " Use spaces instead of tabs
" set smarttab        " Be smart when using tabs ;)

" set tabstop=4               " 1 tab == 4 spaces
" set shiftwidth=4            " indent number

" set autoindent              " Auto indent
" set smartindent             " Smart indent
" set cindent                 " 自动缩进4空格
" set cinoptions=:0
" endif

"set list                        "设置制表符成为可见的字符
set listchars=tab:>-,trail:-    "使制表符以">---"显示, 同时行尾空格以"-"显示"

"----------------------------------------------------------------------
" display

syntax enable                   " 打开语法高亮
syntax on                       " 自动语法高亮

" Set extra options when running in GUI mode
if has("gui_running")
    "au GUIEnter * simalt ~x     " 窗口启动时自动最大化
    "winpos 20 20               " 指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=30 columns=90    " 指定窗口大小，lines为高度，columns为宽度
    "set guioptions-=L          " 隐藏左侧滚动条
    "set guioptions-=r          " 隐藏右侧滚动条
    "set guioptions-=b          " 隐藏底部滚动条
    set showtabline=1           " 隐藏Tab栏为1个时
    set guioptions-=T           " 隐藏工具栏
    set guioptions-=m           " 隐藏菜单栏
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

"----------------------------------------------------------------------
" encode.

if has("multi_byte")
    set encoding=utf-8
    " if has("win32unix")
        " set termencoding=cp936
    " else
        set termencoding=utf-8
    " endif
    set formatoptions+=mM
    set fencs=utf-8,gbk
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif

    try
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
        set langmenu=zh_CN.UTF-8
        language messages zh_CN.utf-8
        " set guifont=Inconsolata_for_Powerline:h12:cANSI   " 设置字体 以及中文支持
	set guifont=Consolas_NF:h12:cANSI
    catch
        throw ""
    endtry
else
    echoerr "sorry, this version of (g)vim was not compiled with +multi_byte!"
endif

