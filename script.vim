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

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
silent! call plug#begin($FCVIM_ROOT . '/plugged')

"----------------------------------------------------------------------
" Make sure you use single quotes

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

"----------------------------------------------------------------------
" deoplete
if 0
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" c/c++/objc/objc++
Plug 'Shougo/deoplete-clangx'
Plug 'Shougo/neoinclude.vim'

" tags
" Plug 'deoplete-plugins/deoplete-tag'
endif
"----------------------------------------------------------------------
" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'

"----------------------------------------------------------------------
" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"----------------------------------------------------------------------
" Plug 'millermedeiros/vim-statline'
" Plug 'fholgado/minibufexpl.vim'
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

"----------------------------------------------------------------------
" Plug 'vim-scripts/a.vim'
" using :CocCommand clangd.switchSourceHeader instend

"----------------------------------------------------------------------
Plug 'preservim/nerdcommenter'

"----------------------------------------------------------------------
Plug 'vim-scripts/DoxygenToolkit.vim'

"----------------------------------------------------------------------
" Plug 'mbbill/echofunc'

"----------------------------------------------------------------------
Plug 'yqking/visualmark'

"----------------------------------------------------------------------
" Plug 'jeaye/color_coded'
Plug 'vim-scripts/EasyColour'
" Plug 'vim-scripts/TagHighlight'

Plug 'vivien/vim-linux-coding-style'

" Plug 'vim-scripts/STL-Syntax'

" Plug $FCVIM_ROOT . '/plugged/std_c'
"----------------------------------------------------------------------
" Plug 'mattn/vimtweak'

"----------------------------------------------------------------------
Plug 'liuchengxu/vista.vim'
" Plug 'preservim/tagbar', { 'on':  'TagbarToggle' }

" Unmanaged plugin (manually installed and updated)
" Plug $FCVIM_ROOT . '/plugged/taglist'

" Initialize plugin system
call plug#end()


"   功能规划：
"       01. TagList             查看函数列表（需要ctags支持）
"     - 02. WinManager          窗口管理程序（可以和其他窗口结合使用）
"       03. MiniBufExplorer     快速浏览和操Buffer
"       04. VisualMark          可显示的标签
"       05. A                   c/h文件间相互切换
"     - 06. Grep                在工程中查找
"       07. SuperTab            加速你的补全
"       08. echofunc            提示函数原形
"       09. omnicppcoplete      C++补全
"       10. statline            状态栏
"       11. xptemplate          块补全
"       12. neocomplcache       带缓冲的补全
"       13. NERD_commenter      注释代码用的
"       14. yankring            剪贴板
"     - 15. txtbrowser          文本阅读
"     - 16. authorinfo          头注释
"       17.TagHighlight         高亮配置
"       18.doxygen toolkit      自动源文件注释 
"       19.vimtweak             windows窗口控制
"

"-----------------------------------------------------------------
"   NERD_tree   以树状方式浏览系统中的文件和目录
" :ERDtree 打开NERD_tree         :NERDtreeClose    关闭NERD_tree
" o 打开关闭文件或者目录         t 在标签页中打开
" T 在后台标签页中打开           ! 执行此文件
" p 到上层目录                   P 到根目录
" K 到第一个节点                 J 到最后一个节点
" u 打开上层目录                 m 显示文件系统菜单（添加、删除、移动操作）
" r 递归刷新当前目录             R 递归刷新当前根目录
"-----------------------------------------------------------------
let NERDChristmasTree=1
let NERDTreeAutoCenter=1
"let NERDTreeBookmarksFile=$VIM.'\Data\NerdBookmarks.txt'
let NERDTreeMouseMode=2
"let NERDTreeShowBookmarks=1
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
"let NERDTreeShowLineNumbers=1
let NERDTreeWinPos='left'





"-----------------------------------------------------------
"   1.taglist   查看函数列表（需要ctags支持）
"     tagbar
"     vista
"-----------------------------------------------------------
" taglist
if 0
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

"-----------------------------------------------------------
" tagbar
if 0
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

"-----------------------------------------------------------
" vista
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




"-----------------------------------------------------------
"   2.WinManager    窗口管理程序（可以和其他窗口结合使用）
"-----------------------------------------------------------
"let g:winManagerWindowLayout='FileExplorer|BufExplorer|TagList'
"let g:winManagerWindowLayout='FileExplorer'
"let g:persistentBehaviour=0             " 只剩一个窗口时, 退出vim.
"let g:winManagerWidth=20
"let g:defaultExplorer=1
"nmap <silent> <leader>fir :FirstExplorerWindow<cr>
"nmap <silent> <leader>bot :BottomExplorerWindow<cr>





"-----------------------------------------------------------
"   3.MiniBufExplorer    快速浏览和操Buffer
"-----------------------------------------------------------
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
" let g:miniBufExplorerMoreThanOne=2      " 等于此数自动弹出
let g:miniBufExplorerMoreThanOne=0      " 解决各窗口不兼容







"-----------------------------------------------------------
"   4.VisualMark    可显示的标签
"-----------------------------------------------------------
if &bg == "dark"    " 根据你的背景色风格来设置不同的书签颜色 
    highlight SignColor ctermfg=white ctermbg=blue guifg=wheat guibg=peru
else                " 主要就是修改guibg的值来设置书签的颜色 
    highlight SignColor ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
endif




"-----------------------------------------------------------
"   5.A    c/h文件间相互切换
"-----------------------------------------------------------
"let g:alternateExtensions_cxx = "H"
"let g:alternateExtensions_H = "cxx"
let g:alternateSearchPath = 'sfr:../src,sfr:../include,reg:|src[^/]|include/\1||,reg:|include[^/]|src/\1||'





"-----------------------------------------------------------
"   6.Grep    在工程中查找
"-----------------------------------------------------------
"nnoremap <silent> <F3> :Grep<CR>




"-----------------------------------------------------------
"   7.SuperTab    加速你的补全
"-----------------------------------------------------------
" let g:SuperTabRetainCompletionType=2
" let g:SuperTabDefaultCompletionType="<C-X><C-U>"




"-----------------------------------------------------------
"   8.echofunc  提示函数原形
"-----------------------------------------------------------
" let g:EchoFuncKeyNext='<Esc>='
" let g:EchoFuncKeyPrev='<Esc>-'




"-----------------------------------------------------------
"   9.omnicppcoplete    C++补全
"-----------------------------------------------------------




"-----------------------------------------------------------
"   10.statline    状态栏
"-----------------------------------------------------------




"-----------------------------------------------------------
"   11.xptemplate    块补全
"-----------------------------------------------------------




"-----------------------------------------------------------
"   12.neocomplcache    带缓冲的补全
"-----------------------------------------------------------




"-----------------------------------------------------------------
"   13.NERD_commenter   注释代码用的，
" [count],cc 光标以下count行逐行添加注释(7,cc)
" [count],cu 光标以下count行逐行取消注释(7,cu)
" [count],cm 光标以下count行尝试添加块注释(7,cm)
" ,cA 在行尾插入 /* */,并且进入插入模式。 这个命令方便写注释。
" 注：count参数可选，无则默认为选中行或当前行
"-----------------------------------------------------------------
let NERDSpaceDelims=1       " 让注释符与语句之间留一个空格
let NERDCompactSexyComs=1   " 多行注释时样子更好看




"-----------------------------------------------------------
"   14.yankring    剪贴板
"-----------------------------------------------------------




"-----------------------------------------------------------
"   15.txtbrowser    文本阅读
"-----------------------------------------------------------
"syntax on
"filetype plugin on
" au BufEnter *.txt setlocal ft=txt
" let Txtbrowser_Search_Engine='http://www.baidu.com/s?wd=text&oq=text&f=3&rsp=2'




"-----------------------------------------------------------
"   16.authorinfo    头注释
"-----------------------------------------------------------
" let g:vimrc_author='方窗'
" let g:vimrc_email='fangchuang@live.cn'
" let g:vimrc_homepage='http://blog.csdn.net/fangchuang'




"--------------------------------------------------------
"   17.TagHighlight  高亮配置
"--------------------------------------------------------
if !exists('g:TagHighlightSettings')
    let g:TagHighlightSettings = {}
endif
" let g:TagHighlightSettings['ForcedPythonVariant'] = 'compiled'
" let g:TagHighlightSettings['DebugLevel'] = 'Information'
" let g:TagHighlightSettings['DebugFile'] = './typesonly.log'




"--------------------------------------------------------
"   18.doxygen toolkit 
"--------------------------------------------------------
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




"--------------------------------------------------------
"   19.vimtweak 
"--------------------------------------------------------
" 进入GUI自动窗口透明，最大化，最前端。
if !has('unix')
    if !exists('g:vimtweak_dll_path')   
        let g:vimtweak_dll_path = $FCVIM_TOOLS . '/vimtweak.dll'
    endif
    autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "SetAlpha", 200)
    autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "EnableMaximize", 1)
    autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "EnableTopMost", 1)
    autocmd GUIEnter * call libcallnr(g:vimtweak_dll_path, "EnableCaption", 1)
endif




"--------------------------------------------------------
"   20.airline 
"--------------------------------------------------------
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




"--------------------------------------------------------
"   21.EasyColour 
"--------------------------------------------------------

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
" 设置保护色
" highlight Normal guifg=black guibg=#cce8cf




"--------------------------------------------------------
"   22.deoplete 
"      coc
"--------------------------------------------------------
" deoplete
if has_key(g:plugs, "deoplete.nvim")
" 自启动
let g:deoplete#enable_at_startup = 1

" disable the buffer and around source.
call deoplete#custom#option('ignore_sources', {'_': ['buffer', 'around']})

" others
call deoplete#custom#option({
			\ 'auto_complete_delay': 10,
			\ 'auto_refresh_delay': 1000,
			\ 'max_list': 200,
			\ 'smart_case': v:false,
			\ 'camel_case': v:false,
			\ 'ignore_case': v:true,
			\ })

" 用户输入至少4个字符时再开始提示补全
call deoplete#custom#source('_',
			\ 'min_pattern_length',
			\ 3)

" Change the truncate width.
call deoplete#custom#source('clangx',
			\ 'max_abbr_width', 30)
call deoplete#custom#source('clangx',
			\ 'max_menu_width', 100)
call deoplete#custom#source('clangx',
			\ 'max_info_width', 200)
call deoplete#custom#source('clangx',
			\ 'max_kind_width', 40)

" libclang: '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
" Change clang binary path
" call deoplete#custom#var('clangx', 'clang_binary', '/usr/bin/clang')

" Change clang options
" call deoplete#custom#var('clangx', 'default_c_options', '')
" call deoplete#custom#var('clangx', 'default_cpp_options', '')

" 补全结束或离开插入模式时，关闭预览窗口
" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

" 头文件路径
" let g:neoinclude#_paths = {}
let g:neoinclude#paths = {
			\ 'c': './,../include,../references,/usr/local/include',
			\ 'cpp': './,../include,../references,/usr/local/include',
			\ }

if has('win32unix')
let g:python3_host_prog = '/usr/bin/python'
endif

endif

"--------------------------------------------------------
" coc
if has_key(g:plugs, "coc.nvim")
if $FCVIM_OS == 'windows'
	let g:coc_node_path = 'C:/Program Files/nodejs/node'
endif
let g:coc_disable_startup_warning = v:true
let g:coc_global_extensions = ['coc-json', 'coc-clangd']

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
			\ 'minTriggerInputLength': 3,
			\ 'maxCompleteItemCount': 100,
			\ 'autoTrigger': 'none',
			\ 'defaultSortMethod': 'length',
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
call coc#config('coc.preferences', {
			\ 'rootPatterns': ['.vns', '.svn', '.git', '.hg', '.projections.json'],
			\})
call coc#config('coc.source', {
			\ 'around': { 'enable': v:false },
			\ 'buffer': { 'enable': v:false },
			\ 'file': { 'enable': v:false },
			\})
if $FCVIM_OS == 'windows'
	" maybe path: 'C:/Program Files/LLVM/bin/clangd',
	let $FCVIM_TOOLS_CLANGD = $FCVIM_TOOLS . '/clangd'
elseif $FCVIM_OS == 'mac'
	let $FCVIM_TOOLS_CLANGD = '/Library/Developer/CommandLineTools/usr/bin/clangd'
else
	let $FCVIM_TOOLS_CLANGD = 'clangd'
endif
call coc#config('clangd', {
			\ 'path': $FCVIM_TOOLS_CLANGD,
			\ 'semanticHighlighting': v:true,
			\ 'arguments': ['-j=4', '--pch-storage=memory'],
			\})
endif "----------------------------------------



