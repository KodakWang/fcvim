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

call plug#begin($FCVIM_ROOT . '/plugged')
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" LSP语言服务协议框架
if v:version < 802 " 高版本的coc不兼容vim8.2之前的版本
	Plug 'neoclide/coc.nvim', {'tag': 'v0.0.80'}
	Plug 'jackguo380/vim-lsp-cxx-highlight'
else
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" 风格样式
" Plug 'vim-scripts/EasyColour'
Plug 'joshdick/onedark.vim'
" 配合EasyColour插件的高亮（需要ctags）
" Plug 'vim-scripts/TagHighlight'
" linux代码风格
" Plug 'vivien/vim-linux-coding-style'
" 插件图标
" Plug 'ryanoasis/vim-devicons'
" 缩进线
Plug 'Yggdroot/indentLine'

" 标题状态栏
"- Plug 'fholgado/minibufexpl.vim'
"- Plug 'millermedeiros/vim-statline'
Plug 'vim-airline/vim-airline'
" airline的主题
" Plug 'vim-airline/vim-airline-themes'

" 符号文件浏览器
" 符号浏览器
"- Plug $FCVIM_ROOT . '/plugged/taglist'
"- Plug 'preservim/tagbar', { 'on':  'TagbarToggle' }
Plug 'liuchengxu/vista.vim'
" 文件浏览器
if v:version < 802 " 高版本使用coc-explorer（尽量兼容nerdtree的快捷键）
    Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
endif

" 代码
" 代码注释
Plug 'preservim/nerdcommenter'
" doxygen注释
Plug 'vim-scripts/DoxygenToolkit.vim'
" shell格式化插件
if $FCVIM_OS == "windows"
    Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
endif

" 索引跳转
" 头文件和源文件之间的切换(代替:CocCommand clangd.switchSourceHeader)
"- Plug 'vim-scripts/a.vim'
" 书签标记
"- Plug 'yqking/visualmark'
Plug 'MattesGroeger/vim-bookmarks'
" fzf工具
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" fzf工具封装
Plug 'junegunn/fzf.vim'

" 其他
" 剪切板
Plug 'vim-scripts/YankRing.vim'
" 窗口透明度和大小控制（需要windows系统，仓库的dll版本不对）
" Plug 'mattn/vimtweak'

" Initialize plugin system
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

"-------------------------------------------------------------------------------
" LSP语言服务协议框架

if has_key(g:plugs, "coc.nvim")
	if $FCVIM_OS == 'windows'
		if !filereadable('C:/Program Files/nodejs/node')
			let g:coc_node_path = 'node'
		else
			let g:coc_node_path = 'C:/Program Files/nodejs/node'
		endif
	endif
	let g:coc_disable_startup_warning = v:true
	if v:version < 802
		" 第一次安装coc可能会直接安装最新版本的拓展插件（v0.0.73后的版本都会）
		" 可以手动安装指定版本的拓展插件，如：CocInstall coc-clangd@0.18.2
		" 以下方式会在vim启动加载coc插件时自动安装拓展插件
		let g:coc_global_extensions = ['coc-json', 'coc-clangd@0.18.2']
		call coc#config('coc.preferences', {
					\ 'rootPatterns': ['.svn', '.git', '.hg', '.projections.json'],
					\ 'semanticTokensHighlights': v:false,
					\})
		" 配置拓展插件，以下方式类似设置languageserver且各插件可单独配
		call coc#config('clangd', {
					\ 'path': $FCVIM_TOOLS_CLANGD,
					\ 'arguments': ['-j=4', '--pch-storage=memory', '--compile-commands-dir=' . $FCVIM_TOOLS_CLANGD_CFLAGSDIR],
					\ 'semanticHighlighting': v:true,
					\})
	else
		let g:coc_global_extensions = ['coc-json', 'coc-clangd', 'coc-pyright', 'coc-go']
		if !has_key(g:plugs, "nerdtree")
			let g:coc_global_extensions += ['coc-explorer']
            call coc#config('explorer.icon', {
                        \ 'enableNerdfont': v:true,
                        \})
            call coc#config('explorer.file.reveal', {
                        \ 'whenOpen': v:false,
                        \})
            " call coc#config('explorer.root', {
                        " \ 'strategies': [ 'keep', ],
                        " \})
            call coc#config('explorer.sources', [
                        \ { 'name': 'file', 'expand': v:true, },
                        \])
            call coc#config('explorer', {
                        \ 'keyMappingMode': 'none',
                        \})
            call coc#config('explorer.keyMappings.global', {
                        \ "<tab>": "actionMenu",
                        \ "?": "help",
                        \ "I": "toggleHidden",
                        \ "<cr>": ["wait", "expandable?", ["expanded?", "collapse", "expand"], "open"],
                        \ "u": ["wait", "gotoParent", "collapse"],
                        \ "U": ["wait", "gotoParent", "indentPrev"],
                        \ "C": "cd",
                        \ "ma": "addFile",
                        \ "md": "deleteForever",
                        \ "mp": "copyFilePath",
                        \})
            function FCVIM_CocExplorerGetNodeDir()
                let node = CocAction('runCommand', 'explorer.getNodeInfo', 0)
                if !empty(node)
                   let path = node['fullpath'] 
                   if isdirectory(path)
                       return path
                   endif
                   return fnamemodify(path, ':h')
                endif
                return ""
            endfunction
            autocmd FileType coc-explorer nnoremap <buffer> cd <Cmd>call chdir(FCVIM_CocExplorerGetNodeDir())<CR><Cmd>echo "chdir " . getcwd()<CR>
        endif
		if !has_key(g:plugs, "vim-shfmt")
			let g:coc_global_extensions += ['coc-sh']
        endif
		call coc#config('semanticTokens', {
					\ 'enable': v:true,
					\})
        call coc#config('coc.preferences', {
                    \ 'rootPatterns': ['.svn', '.git', '.hg', '.projections.json'],
                    \})
		call coc#config('clangd', {
					\ 'path': $FCVIM_TOOLS_CLANGD,
					\ 'arguments': ['-j=4', '--pch-storage=memory', '--compile-commands-dir=' . $FCVIM_TOOLS_CLANGD_CFLAGSDIR],
					\})
		call coc#config('go', {
					\ 'goplsPath': $GOPATH . '/bin/gopls',
					\})
	endif

	if v:version >= 900
		" 关闭嵌入提示（函数形参预览）
		call coc#config('inlayHint', {
					\ 'enable': v:false,
					\})
	endif

	" call coc#config('intelephense', {
	" \ 'trace': { 'server': 'messages' }
	" \ 'format': { 'enable': v:true }
	" \ 'completion': {
	" \ 'triggerParameterHints': v:true,
	" \ 'insertUseDeclaration': v:true,
	" \ 'fullyQualifyGlobalConstantsAndFunctions': v:false,
	" \}
	" \})
	call coc#config('suggest', {
				\ 'autoTrigger': 'always',
				\ 'defaultSortMethod': 'length',
				\ 'minTriggerInputLength': 3,
				\ 'maxCompleteItemCount': 100,
				\ 'triggerCompletionWait': 100,
				\ 'enablePreselect': v:false,
				\ 'noselect': v:true,
				\ 'removeDuplicateItems': v:true,
				\})
	call coc#config('suggest.completionItemKindLabels', {
				\ "keyword": "\uf1de",
				\ "variable": "\ue79b",
				\ "value": "\uf89f",
				\ "operator": "\u03a8",
				\ "constructor": "\uf0ad",
				\ "function": "\u0192",
				\ "reference": "\ufa46",
				\ "constant": "\uf8fe",
				\ "method": "\uf09a",
				\ "struct": "\ufb44",
				\ "class": "\uf0e8",
				\ "interface": "\uf417",
				\ "text": "\ue612",
				\ "enum": "\uf435",
				\ "enumMember": "\uf02b",
				\ "module": "\uf40d",
				\ "color": "\ue22b",
				\ "property": "\ue624",
				\ "field": "\uf9be",
				\ "unit": "\uf475",
				\ "event": "\ufacd",
				\ "file": "\uf723",
				\ "folder": "\uf114",
				\ "snippet": "\ue60b",
				\ "typeParameter": "\uf728",
				\ "default": "\uf29c"
				\})
	" call coc#config('diagnostic', {
	" \ 'enable': v:false,
	" \})
	" signature
	" .enable              启用签名帮助（函数定义等）
	" .preferShownAbove    提示浮窗是否显示在光标上方
	call coc#config('signature', {
				\ 'enable': v:true,
				\ 'preferShownAbove': v:false,
				\})
	call coc#config('coc.source', {
				\ 'around': { 'enable': v:false },
				\ 'buffer': { 'enable': v:false },
				\ 'file': { 'enable': v:false },
				\})
endif

"-------------------------------------------------------------------------------
" 样式风格

if has_key(g:plugs, "EasyColour")
	" 尝试设定配色方案
	try
		set background=dark " Change to light if you want the light variant
		colorscheme bandit  " Change to your preferred colour scheme
		" colorscheme desert_thl
	catch
		colorscheme desert
	endtry

	" 光标聚焦颜色（推荐色：DarkGray,Brown,DarkYellow,SlateBlue,SeaGreen）
	if (colors_name == "bandit")
		highlight CursorLine term=underline cterm=underline ctermbg=DarkYellow guibg=DarkYellow
		highlight CursorColumn term=reverse ctermbg=DarkYellow guibg=DarkYellow
	elseif (colors_name == "desert")
		highlight CursorLine term=underline cterm=underline ctermbg=DarkGray guibg=DarkGray
		highlight CursorColumn term=reverse ctermbg=DarkGray guibg=DarkGray
	endif
endif

if has_key(g:plugs, "TagHighlight")
       if !exists('g:TagHighlightSettings')
               let g:TagHighlightSettings = {}
       endif
       " let g:TagHighlightSettings['ForcedPythonVariant'] = 'compiled'
       " let g:TagHighlightSettings['DebugLevel'] = 'Information'
       " let g:TagHighlightSettings['DebugFile'] = './typesonly.log'
endif

if has_key(g:plugs, 'onedark.vim')
	"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
	"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
	"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
	if (empty($TMUX))
		if (has("nvim"))
			"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
			let $NVIM_TUI_ENABLE_TRUE_COLOR=1
		endif
		"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
		"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
		" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
		if (has("termguicolors"))
			set termguicolors
		endif
	endif

	" 设置主题
	colorscheme onedark
endif

if has_key(g:plugs, 'indentLine')
    " 显示第一列缩进线
    let g:indentLine_showFirstIndentLevel = 1

    " 让 indentLine 显示¦
    let g:indentLine_char = '¦'

    " 排除一些不兼容的文件类型
    let g:indentLine_fileTypeExclude = ['json', 'coc-explorer']
endif

" 更好的支持各种模式下的背景透明
if has("gui_running")
	" 设置保护色
	" highlight Normal guifg=black guibg=#cce8cf

	" 设置背景透明
	" highlight Normal guibg=None
	" highlight NonText guibg=None
else
	" 设置背景透明
	highlight Normal ctermbg=None guibg=NONE
	highlight NonText ctermbg=None guibg=NONE
endif

"-------------------------------------------------------------------------------
" 标题状态栏

if has_key(g:plugs, "minibufexpl.vim")
	let g:miniBufExplMapWindowNavVim=1
	let g:miniBufExplMapWindowNavArrows=1
	let g:miniBufExplMapCTabSwitchBufs=1
	let g:miniBufExplModSelTarget=1
	" let g:miniBufExplorerMoreThanOne=2      " 等于此数自动弹出
	let g:miniBufExplorerMoreThanOne=0      " 解决各窗口不兼容
endif

if has_key(g:plugs, "vim-airline")
	let g:airline#extensions#tabline#enabled = 1
	" 标签显示buffer编号
	let g:airline#extensions#tabline#buffer_nr_show = 1
	" 标签显示buffer编号的格式
	let g:airline#extensions#tabline#buffer_nr_format = '%s:'
	" 标签只显示文件名
	let g:airline#extensions#tabline#fnamemod = ':t'
	" 制表符和空格对齐提示
	let g:airline#extensions#whitespace#mixed_indent_algo = 1

	" let g:airline#extensions#tabline#left_sep = ''
	" let g:airline#extensions#tabline#left_alt_sep = ''
	" let g:airline#extensions#tabline#right_sep = ''
	" let g:airline#extensions#tabline#right_alt_sep = ''

	let g:airline_powerline_fonts = 1
	" let g:airline_symbols_ascii = 1

	" if !exists('g:airline_symbols')
	" let g:airline_symbols = {}
	" endif

	" unicode symbols
	" let g:airline_left_sep = '»'
	" let g:airline_left_sep = '▶'
	" let g:airline_right_sep = '«'
	" let g:airline_right_sep = '◀'
	" let g:airline_symbols.crypt = '🔒'
	" let g:airline_symbols.linenr = '☰'
	" let g:airline_symbols.linenr = '␊'
	" let g:airline_symbols.linenr = '␤'
	" let g:airline_symbols.linenr = '¶'
	" let g:airline_symbols.maxlinenr = ''
	" let g:airline_symbols.maxlinenr = '㏑'
	" let g:airline_symbols.branch = '⎇'
	" let g:airline_symbols.paste = 'ρ'
	" let g:airline_symbols.paste = 'Þ'
	" let g:airline_symbols.paste = '∥'
	" let g:airline_symbols.spell = 'Ꞩ'
	" let g:airline_symbols.notexists = 'Ɇ'
	" let g:airline_symbols.whitespace = 'Ξ'

	" powerline symbols
	" let g:airline_left_sep = ''
	" let g:airline_left_alt_sep = ''
	" let g:airline_right_sep = ''
	" let g:airline_right_alt_sep = ''
	" let g:airline_symbols.branch = ''
	" let g:airline_symbols.readonly = ''
	" let g:airline_symbols.linenr = '☰'
	" let g:airline_symbols.maxlinenr = ''
	" let g:airline_symbols.dirty='⚡'

	" 更换反向箭头（默认反向箭头间隙太大）
	let g:airline_right_sep = '◄'
	let g:airline_right_alt_sep = '＜'
	" 排除一些窗口的状态栏功能
	let g:airline_filetype_overrides = {
				\ 'vista' : [ 'Vista', '' ],
				\ }
	let g:airline_exclude_preview = 0
endif

"-------------------------------------------------------------------------------
" 符号文件浏览器

if has_key(g:plugs, "taglist")
	" 不支持中文问题： silent echo ctags_cmd 替换为 silent echon ctags_cmd 生成的 taglist.cmd 将不包含换行,即无所谓 fileformat
	let Tlist_Ctags_Cmd = '"' . $FCVIM_TOOLS . '/ctags"'
	let Tlist_Show_One_File = 1            " 不同时显示多个文件的tag，只显示当前文件的
	let Tlist_Exit_OnlyWindow = 1          " 如果taglist窗口是最后一个窗口，则退出vim
	let Tlist_Use_Right_Window = 1         " 在右侧窗口中显示taglist窗口
	let Tlist_File_Fold_Auto_Close=1       " 自动折叠当前非编辑文件的方法列表
	let Tlist_Auto_Open = 0
	let Tlist_Auto_Update = 1
	let Tlist_Hightlight_Tag_On_BufEnter = 1
	let Tlist_Enable_Fold_Column = 0
	let Tlist_Process_File_Always = 1
	let Tlist_Display_Prototype = 0
	let Tlist_Compact_Format = 1
endif

if has_key(g:plugs, "tagbar")
	let g:tagbar_ctags_bin = $FCVIM_TOOLS . '/ctags'
	" 让tagbar在页面左侧显示，默认右边
	" let g:tagbar_left = 1
	" 设置tagbar的宽度为30列，默认40
	let g:tagbar_width = 30
	" 这是tagbar一打开，光标即在tagbar页面内，默认在vim打开的文件内
	let g:tagbar_autofocus = 1
	" 设置标签不排序，默认排序
	let g:tagbar_sort = 0
endif

if has_key(g:plugs, "vista.vim")
	let g:vista_sidebar_width = 35
	" How each level is indented and what to prepend.
	" This could make the display more compact or more spacious.
	" e.g., more compact: ["▸ ", ""]
	" Note: this option only works for the kind renderer, not the tree renderer.
	let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

	" Executive used when opening vista sidebar without specifying it.
	" See all the avaliable executives via `:echo g:vista#executives`.
	let g:vista_default_executive = 'ctags'

	" Set the executive for some filetypes explicitly. Use the explicit executive
	" instead of the default one for these filetypes when using `:Vista` without
	" specifying the executive.
	let g:vista_executive_for = {
				\ 'cpp': 'coc',
				\ 'c': 'coc',
				\ 'h': 'coc',
				\ 'hpp': 'coc',
				\ 'hxx': 'coc',
				\ }

	" Declare the command including the executable and options used to generate ctags output
	" for some certain filetypes.The file path will be appened to your custom command.
	" For example:
	let g:vista_ctags_cmd = {
				\ 'haskell': 'hasktags -x -o - -c',
				\ }

	" To enable fzf's preview window set g:vista_fzf_preview.
	" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
	" For example:
	let g:vista_fzf_preview = ['right:50%']

	" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
	let g:vista#renderer#enable_icon = 1

	" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
	let g:vista#renderer#icons = {
				\   "function": "\uf794",
				\   "variable": "\uf71b",
				\  }
endif

if has_key(g:plugs, "nerdtree")
	" NERD_tree   以树状方式浏览系统中的文件和目录
	" :ERDtree 打开NERD_tree         :NERDtreeClose    关闭NERD_tree
	" o 打开关闭文件或者目录         t 在标签页中打开
	" T 在后台标签页中打开           ! 执行此文件
	" p 到上层目录                   P 到根目录
	" K 到第一个节点                 J 到最后一个节点
	" u 打开上层目录                 m 显示文件系统菜单（添加、删除、移动操作）
	" r 递归刷新当前目录             R 递归刷新当前根目录
	let NERDChristmasTree=1
	let NERDTreeAutoCenter=1
	let NERDTreeMouseMode=2
	if empty($FCVIM_TOPDIR)
		let NERDTreeBookmarksFile = '.NERDTreeBookmarks'
	else
		let NERDTreeBookmarksFile = $FCVIM_TOPDIR . '/.NERDTreeBookmarks'
	endif
	"let NERDTreeShowBookmarks=1
	let NERDTreeShowFiles=1
	let NERDTreeShowHidden=0
	" let NERDTreeShowLineNumbers=1
	let NERDTreeWinPos='left'
	let NERDTreeMinimalUI = 1
endif

"-------------------------------------------------------------------------------
" 代码

if has_key(g:plugs, "nerdcommenter")
	" [count],cc 光标以下count行逐行添加注释(7,cc)
	" [count],cu 光标以下count行逐行取消注释(7,cu)
	" [count],cm 光标以下count行尝试添加块注释(7,cm)
	" ,cA 在行尾插入 /* */,并且进入插入模式。 这个命令方便写注释。
	" 注：count参数可选，无则默认为选中行或当前行
	let NERDSpaceDelims=1       " 让注释符与语句之间留一个空格
	let NERDCompactSexyComs=1   " 多行注释时样子更好看
endif

if has_key(g:plugs, "DoxygenToolkit.vim")
	" let g:DoxygenToolkit_briefTag_pre="@synopsis  "
	" let g:DoxygenToolkit_paramTag_pre="@param "
	" let g:DoxygenToolkit_returnTag="@returns   "
	" let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
	" let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
	" let g:DoxygenToolkit_authorName="Drunkedcat"
	" let g:DoxygenToolkit_licenseTag="GPL 2.0"

	" let g:DoxygenToolkit_authorName="drunkedcat, whitelilis@gmail.com"
	" let s:licenseTag = "Copyright(C)\<enter>"
	" let s:licenseTag = s:licenseTag . "For free\<enter>"
	" let s:licenseTag = s:licenseTag . "All right reserved\<enter>"
	" let g:DoxygenToolkit_licenseTag = s:licenseTag
	" let g:DoxygenToolkit_briefTag_funcName="yes"
	" let g:doxygen_enhanced_color=1
endif

if has_key(g:plugs, "vim-shfmt")
    autocmd FileType sh nnoremap <buffer><silent> <leader>fd <Cmd>execute 'Shfmt -i ' . &l:shiftwidth . ' -ln auto -sr -ci -s'<CR>
endif

"-------------------------------------------------------------------------------
" 索引跳转

if has_key(g:plugs, "a.vim")
	"let g:alternateExtensions_cxx = "H"
	"let g:alternateExtensions_H = "cxx"
	let g:alternateSearchPath = 'sfr:../src,sfr:../include,reg:|src[^/]|include/\1||,reg:|include[^/]|src/\1||'
endif

if has_key(g:plugs, "visualmark")
	if &bg == "dark"    " 根据你的背景色风格来设置不同的书签颜色
		highlight SignColor ctermfg=white ctermbg=blue guifg=wheat guibg=peru
	else                " 主要就是修改guibg的值来设置书签的颜色
		highlight SignColor ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
	endif
endif

if has_key(g:plugs, "vim-bookmarks")
	if empty($FCVIM_TOPDIR)
		let g:bookmark_auto_save_file = $FCVIM_TEMP . '/.vim-bookmarks'
	else
		let g:bookmark_auto_save_file = $FCVIM_TOPDIR . '/.vim-bookmarks'
	endif

	" 书签可以改成自己喜欢的符号，如: ⚑、★或♥
	let g:bookmark_sign = '☆'
	let g:bookmark_annotation_sign = '★'

	" let g:bookmark_highlight_lines = 1
	" if &bg == "dark"    " 根据你的背景色风格来设置不同的书签颜色
		" highlight BookmarkSign ctermfg=white ctermbg=blue guifg=wheat guibg=peru
		" highlight BookmarkAnnotationSign ctermfg=white ctermbg=blue guifg=wheat guibg=peru
		" highlight BookmarkLine ctermfg=white ctermbg=blue guifg=wheat guibg=peru
		" highlight BookmarkAnnotationLine ctermfg=white ctermbg=blue guifg=wheat guibg=peru
	" else                " 主要就是修改guibg的值来设置书签的颜色
		" highlight BookmarkSign ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
		" highlight BookmarkAnnotationSign ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
		" highlight BookmarkLine ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
		" highlight BookmarkAnnotationLine ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
	" endif
endif

" if has_key(g:plugs, "fzf")
" endif

"-------------------------------------------------------------------------------
" 其他

if has_key(g:plugs, "YankRing.vim")
	let yankring_min_element_length = 2
endif

if has_key(g:plugs, "vimtweak") || $FCVIM_OS == 'windows'
	" 进入GUI自动窗口透明，最大化，最前端。
	if !has('unix')
		if !exists('g:vimtweak_dll_path')
			let g:vimtweak_dll_path = $FCVIM_TOOLS . '/vimtweak.dll'
		endif

		if has_key(g:plugs, "EasyColour")
			autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "SetAlpha", 200)
		else
			" 获取 Normal 高亮组的 guibg 值
			" let guibg_color = matchstr(execute('hi Normal'), 'guibg=#\(\w\+\)')
			" 提取颜色的十六进制值
			" let hex_value = substitute(guibg_color, 'guibg=#', '', '')
			" 这种方法无法生效
			" autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "SetAlpha", str2nr(hex_value, 16))
		endif
		autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "EnableMaximize", 1)
		autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "EnableTopMost", 1)
		autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "EnableCaption", 1)
	endif
endif

