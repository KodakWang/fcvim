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

" Make sure you use single quotes

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Plug 'millermedeiros/vim-statline'
" Plug 'fholgado/minibufexpl.vim'
Plug 'vim-airline/vim-airline'

Plug 'vim-scripts/a.vim'

Plug 'preservim/nerdcommenter'

Plug 'vim-scripts/EasyColour'

Plug 'vim-scripts/DoxygenToolkit.vim'

Plug 'mbbill/echofunc'

Plug 'yqking/visualmark'

Plug 'vim-scripts/TagHighlight'

Plug 'vim-scripts/linuxsty.vim'

Plug 'vim-scripts/STL-Syntax'

" Plug 'mattn/vimtweak'

" Unmanaged plugin (manually installed and updated)
Plug $FCVIM_ROOT . '/plugged/taglist'
Plug $FCVIM_ROOT . '/plugged/std_c'

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
"-----------------------------------------------------------
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
let g:EchoFuncKeyNext='<Esc>='
let g:EchoFuncKeyPrev='<Esc>-'




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
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''




