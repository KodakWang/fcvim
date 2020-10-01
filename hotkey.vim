"
" FCVIM: Advanced VIM.
"
" Copyright (C) 2013-2014 Kodak Wang. All rights reserved.
"
" Created by FangChuang(方窗) <kodakwang@gmail.com>
"
" Please do not reproduced, distribute or quote without written
" permission of the author. This software is not perfect, any
" problems arising from the use, have nothing to do with the author.
"
" Note: FangChuang is the author's pseudonym.
"

try
    if exists('g:fcvim_loaded_hotkey') || &compatible
        throw 'already loaded' . expand('<sfile>') . '!!!!'
    endif
catch
    finish
endtry
let g:fcvim_loaded_hotkey = 1

" With a map leader it's possible to do extra key combinations
let mapleader = ","
let g:mapleader = ","

"----------------------------------------------------------------------
" script

" NERDTree 切换
map <leader>[ :NERDTreeToggle<CR>

map <leader>] :TlistToggle<CR>

map <leader>\ :YRShow<CR>

map <leader>' :MBEToggle<CR>

" vimgrep搜索结果框
map <leader>; :call FCVIM_ToggleQuickFix()<cr>
map <leader>n :cnext<cr>
map <leader>N :cprevious<cr>

" 复制按键必须放在后面，否则会被影响
" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader>G :vimgrep // <C-R>%<Home><right><right><right><right><right><right><right><right><right>

" When you press ,g or ,G you vimgrep after the selected text
vnoremap <silent> <leader>g :call VisualSelection('g') \| emenu Foo.Bar<CR>
vnoremap <silent> <leader>G :call VisualSelection('G') \| emenu Foo.Bar<CR>

" VisualMark
map <silent> <unique> mm <Plug>Vm_toggle_sign
map <unique> m, <Plug>Vm_goto_next_sign
map <unique> m. <Plug>Vm_goto_prev_sign

"----------------------------------------------------------------------
" misc

" 不受行距影响的上下移动（为了兼容XPT）
" map j gj
" map k gk

" Remap VIM 0 to first non-blank character（为了兼容XPT）
" map 0 ^

" 文件基本操作
nmap <leader>w :w!<CR>
nmap <leader>q :call FCVIM_BufferClose(0)<CR>
nmap <leader>x :w!<CR>:call FCVIM_BufferClose(0)<CR>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" 模仿windows保存
nmap <C-s> :wa<cr>
imap <C-s> <Esc>:wa<cr>a
vmap <C-s> <Esc>:wa<cr>gv

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>.m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
noremap <leader>.<space> :%s= *$==<cr>:noh<cr>
noremap <leader>.<cr> :g/^\s*$/d<cr>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace') \| emenu Foo.Bar<CR>

" 快捷注释
nmap <leader>n` :call FCVIM_CommentHeadAdd('FCLIB', 'Kodak Wang', 'Kodak Wang', 'kodakwang@gmail.com')<cr>
nmap <leader>n1 a/*----------------------------------------------------------------------*/<esc>

" 更新数据库tags, cscope
nmap <leader><cr> :call FCVIM_DatabaseCreateAll(FCVIM_FindFileDirUpward('tags'))<CR>
nmap <leader><cr><cr> :call FCVIM_DatabaseCscopeReload(FCVIM_FindFileDirUpward('tags'))<CR>

" Toggle paste mode on and off
map <leader>p :setlocal paste!<cr>

" Pressing ,ss will toggle and untoggle spell checking
map <leader>s :setlocal spell!<cr>

" Disable highlight when <leader>/ is pressed
map <silent><leader>/ :call FCVIM_ToggleHLSearch()<cr>

" 用空格键来开关折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
nnoremap <leader><space> :call FCVIM_ToggleFoldAll()<cr>

" 光标聚焦切换
map <leader>` :call FCVIM_ToggleCursorLine()<CR>

" 制表符显示切换
map <leader><tab> :call FCVIM_ToggleList()<cr>

" 智能tab映射，保证代码前缩进为制表符，代码后则映射为空格
inoremap <silent><tab> <c-r>=FCVIM_KeySmartTab(&shiftwidth)<cr>

" 在需要搜索时打开自动跳转
map / :set incsearch \| unmap /<cr>/
autocmd CmdlineLeave * set noincsearch | map / :set incsearch \| unmap /<cr>/

