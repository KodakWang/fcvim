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
	if exists('g:fcvim_loaded_entry') || &compatible
		throw 'already loaded' . expand('<sfile>') . '!!!!'
	endif
catch
	finish
endtry
let g:fcvim_loaded_entry = 1

"----------------------------------------------------------------------
" Identify the operating system & initialize values

if !exists('$FCVIM_OS')
	if has('mac') || strlen($Apple_PubSub_Socket_Render)
		" 苹果系统识别
		" 之后也可使用stridx($FCVIM_TOOLS, '/local/')>0判断
		" 注：使用has('mac')或has('macunix')无效果
		let $FCVIM_OS = 'mac'
	elseif has('win32') || has('win32unix') || has('win95')
		let $FCVIM_OS = 'windows'
	else
		let $FCVIM_OS = 'unix'
	endif
endif

" if !exists('$FCVIM')
	" let $FCVIM = expand('<sfile>:p:h:h')
" endif

if !exists('$FCVIM_ROOT')
	let $FCVIM_ROOT = expand('<sfile>:p:h')
	" 路径转换
	if $FCVIM_OS == 'windows'
		if has("win32unix") && strpart($FCVIM_ROOT, 2, 1) == '/'
			let $FCVIM_ROOT = strpart($FCVIM_ROOT, 1, 1) . ':' . strpart($FCVIM_ROOT, 2)
		else
			if isdirectory("c:/msys64")
				let $PATH = "c:/msys64/ucrt64/bin;c:/msys64/usr/local/bin;c:/msys64/usr/bin;c:/msys64/bin;" . $PATH
				let $HOME = "c:/msys64/home/" . $USER
			endif
		endif
	endif
endif

if !exists('$FCVIM_TOOLS')
	if $FCVIM_OS == 'mac'
		let $FCVIM_TOOLS = '/usr/local/bin'
	elseif $FCVIM_OS == 'windows'
		let $FCVIM_TOOLS = $FCVIM_ROOT . '/tools'
	else
		let $FCVIM_TOOLS = '/bin'
	endif
endif

if !exists('$FCVIM_TOOLS_CLANGD')
	" coc plugin need clangd path add to Env PATH.
	if executable("clangd")
		let $FCVIM_TOOLS_CLANGD = 'clangd'
	else
		if $FCVIM_OS == 'windows'
			if filereadable('C:/Program Files/LLVM/bin/clangd.exe')
				let $FCVIM_TOOLS_CLANGD = 'C:/Program Files/LLVM/bin/clangd'
			elseif filereadable('C:/Qt/Tools/QtCreator/bin/clang/bin/clangd.exe')
				" let $FCVIM_TOOLS_CLANGD = 'C:/Qt/Tools/QtCreator/bin/clang/bin/clangd'
				let $FCVIM_TOOLS_CLANGD = 'clangd'
				let $PATH = "C:/Qt/Tools/QtCreator/bin/clang/bin;" . $PATH
			else
				let $FCVIM_TOOLS_CLANGD = $FCVIM_TOOLS . '/clangd'
			endif
		elseif $FCVIM_OS == 'mac'
			let $FCVIM_TOOLS_CLANGD = '/Library/Developer/CommandLineTools/usr/bin/clangd'
		else
			let $FCVIM_TOOLS_CLANGD = 'clangd'
		endif
	endif
endif

if !exists('$FCVIM_TEMP')
	if $FCVIM_OS == 'windows'
		let $FCVIM_TEMP = $TEMP
	else
		let $FCVIM_TEMP = '/tmp'
	endif
endif

if !exists('$CSCOPE_DB')
	" cscope add have some bugs, can't support chanese encoding.
	" spacing path can use 'fnamemodify' method convert DOS8.3, but db so ugly.
	" we have to load temp database.
	let $CSCOPE_DB = findfile('cscope.out', '.;')
	" if stridx($CSCOPE_DB, ' ') > 0
	" let $CSCOPE_DB = $FCVIM_TEMP . '/cscope.out'
	" endif
endif

set nocscopeverbose
set cscopeprg=$FCVIM_TOOLS/cscope

"----------------------------------------------------------------------
" load the other scripts.

set runtimepath=$FCVIM_ROOT,$VIMRUNTIME

source $FCVIM_ROOT/config.vim
source $FCVIM_ROOT/function.vim

let $FCVIM_TOOLS_CLANGD_CFLAGSDIR = FCVIM_FindFileDirUpward("compile_flags.txt")
if ($FCVIM_TOOLS_CLANGD_CFLAGSDIR == "")
	let $FCVIM_TOOLS_CLANGD_CFLAGSDIR = FCVIM_FindFileDirUpward("compile_commands.json")
endif

source $FCVIM_ROOT/script.vim
source $FCVIM_ROOT/hotkey.vim

"----------------------------------------------------------------------
" autocmd
" GUIEnter < WinEnter < VimEnter < BufEnter

" , + n 切换
" , + . + n 删除
autocmd BufCreate * call FCVIM_BufferNumberMap(expand('<afile>'))
autocmd BufWipeout * call FCVIM_BufferNumberUnmap(expand('<afile>'))
autocmd VimEnter * call FCVIM_BufferNumberMaps()
" 以下配置在quickfix的显隐中存在bug。
" autocmd BufEnter * call FCVIM_BufferNumberCheck(expand('<afile>'))

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal! g`\"" |
			\ endif

" 每行超过80个的字符用下划线标示
autocmd BufRead,BufNewFile *.s,*.asm,*.h,*.c,*.cpp,*.cc,*.java,*.cs,*.erl,*.hs,*.sh,*.lua,*.pl,*.pm,*.php,*.py,*.rb,*.erb,*.vim,*.js,*.css,*.xml,*.html,*.xhtml 2match Underlined /.\%81v/
" 每行超过80后的每个字符都加下划线
"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)
"au BufRead,BufNewFile *.s,*.asm,*.h,*.c,*.cpp,*.cc,*.java,*.cs,*.erl,*.hs,*.sh,*.lua,*.pl,*.pm,*.php,*.py,*.rb,*.erb,*.vim,*.js,*.css,*.xml,*.html,*.xhtml let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

" 更新文件头注释关键字（这个操作会影响到Redo,Undo）
" autocmd BufWritePre *.[ch],*.cpp call FCVIM_CommentKeysUpdate(20)



