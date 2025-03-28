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
if has_key(g:plugs, "nerdtree")
    map <leader>[ <Cmd>NERDTreeToggle<CR>
else
    map <leader>[ <Cmd>CocCommand explorer<CR>
    " map <leader>[ :Lexplore<CR>
endif

" map <leader>] :TlistToggle<CR>
" map <leader>] :TagbarToggle<CR>
map <leader>] :Vista!!<CR>

" map <leader>' :MBEToggle<CR>
map <leader>' :YRShow<CR>

" vimgrep搜索结果框
map <leader>; :call FCVIM_ToggleQuickFix()<cr>
map <leader>n :cnext<cr>
map <leader>N :cprevious<cr>

" VisualMark
" map <silent> <unique> mm <Plug>Vm_toggle_sign
" map <unique> m, <Plug>Vm_goto_next_sign
" map <unique> m. <Plug>Vm_goto_prev_sign

" fzf
if $FCVIM_OS == 'windows'
    " 全屏显示来规避windows可能出现的显示异常
    map <leader>ff <Cmd>call fzf#vim#files("", fzf#vim#with_preview(), 1)<CR>
    map <leader>fb <Cmd>call fzf#vim#buffers("", fzf#vim#with_preview({ "placeholder": "{1}" }), 1)<CR>
    map <leader>fl <Cmd>call fzf#vim#lines("", 1)<CR>
else
    map <leader>ff :Files<cr>
    map <leader>fb :Buffers<cr>
    map <leader>fl :Lines<cr>
endif

" coc
nnoremap <silent> <leader>fd <Cmd>call CocAction('format')<CR>
nmap <silent><leader>is <Cmd>CocCommand clangd.switchSourceHeader<cr>
" 切换诊断的快捷键
nnoremap <silent><leader>d <Cmd>call FCVIM_ToggleDiagnostic()<CR>

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" " Use <c-space> to trigger completion
" if has('nvim')
  " inoremap <silent><expr> <c-space> coc#refresh()
" else
  " inoremap <silent><expr> <c-@> coc#refresh()
" endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" " Symbol renaming
" nmap <leader>rn <Plug>(coc-rename)

" " Formatting selected code
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json,c,cpp,go,python setl formatexpr=CocAction('formatSelected')
  autocmd FileType sh let &l:formatprg='shfmt -i ' . &l:shiftwidth . ' -ln auto -sr -ci -s'
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" " Applying code actions to the selected code block
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" " Remap keys for applying code actions at the cursor position
" nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" " Remap keys for apply code actions affect whole buffer
" nmap <leader>as  <Plug>(coc-codeaction-source)
" " Apply the most preferred quickfix action to fix diagnostic on the current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" " Remap keys for applying refactor code actions
" nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
" xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" " Run the Code Lens action on the current line
" nmap <leader>cl  <Plug>(coc-codelens-action)

" " Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-S-right> <Plug>(coc-range-select)
xmap <silent> <C-S-right> <Plug>(coc-range-select)

" " Add `:Format` command to format current buffer
" command! -nargs=0 Format :call CocActionAsync('format')

" " Add `:Fold` command to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" " Add (Neo)Vim's native statusline support
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" " Show all diagnostics
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"----------------------------------------------------------------------
" misc

" vim默认键位
" <C-o> 跳转到上一个光标停留的位置
" <C-i> 跳转到下一个光标停留的位置

" 不受行距影响的上下移动（为了兼容XPT）
" map j gj
" map k gk

" Remap VIM 0 to first non-blank character（为了兼容XPT）
" map 0 ^

" 文件基本操作
nmap <leader>w <Cmd>silent! wa<CR>
"nmap <leader>q :call FCVIM_BufferClose(0)<CR>
"nmap <leader>x :w!<CR>:call FCVIM_BufferClose(0)<CR>

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
" nmap <C-s> :wa<cr>
" imap <C-s> <Esc>:wa<cr>a
" vmap <C-s> <Esc>:wa<cr>gv

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>
" cd top
" map <leader>cdt :call chdir($FCVIM_TOPDIR)<cr>:pwd<cr>

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>.m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
" 移除每行多余的空格
noremap <leader>.<space> :%s= *$==<cr>:noh<cr><c-o>
" 移除每行多余的制表符
noremap <leader>.<tab> :%s=\t*$==<cr>:noh<cr><c-o>
" 移除所有的空行
noremap <leader>.<cr> :g/^\s*$/d<cr>

" 记录状态
vmap <silent><leader>, <Esc><Cmd>call FCVIM_RecordVisualSelectionPosition()<cr>
nmap <silent><leader>, <Cmd>call FCVIM_ClearVisualSelectionPosition()<cr>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call FCVIM_VisualSelection('f')<CR>
vnoremap <silent> # :call FCVIM_VisualSelection('b')<CR>

" When you press ,g or ,G you can vimgrep to do something
nmap <silent> <leader>g :call FCVIM_NormalCommand('g') \| emenu Foo.Bar<CR>
nmap <leader>G :vimgrep // <C-R>%<Home><right><right><right><right><right><right><right><right><right>
vnoremap <silent> <leader>g :call FCVIM_VisualSelection('g') \| emenu Foo.Bar<CR>
vnoremap <silent> <leader>G :call FCVIM_VisualSelection('G') \| emenu Foo.Bar<CR>

" When you press ,r or ,R you can replace the selected text or others
nmap <silent> <leader>r :call FCVIM_NormalCommand('r') \| emenu Foo.Bar<CR>
nmap <silent> <leader>R :call FCVIM_NormalCommand('R') \| emenu Foo.Bar<CR>
vnoremap <leader>r :call FCVIM_VisualSelection('r') \| emenu Foo.Bar<CR><Left><Left>
vnoremap <leader>R :call FCVIM_VisualSelection('R') \| emenu Foo.Bar<CR><Left><Left>

" 快捷注释
nmap <leader>n` :call FCVIM_CommentHeadUpdate('Kodak Wang', 'Kodak Wang', 'kodakwang@gmail.com')<cr>
nmap <leader>n1 a/*----------------------------------------------------------------------*/<esc>

" 更新数据库tags, cscope
nmap <leader><cr> :call FCVIM_DatabaseCreateAll(FCVIM_FindFileDirUpward('tags'))<CR>
" nmap <leader><cr><cr> :call FCVIM_DatabaseCscopeReload(FCVIM_FindFileDirUpward('tags'))<CR>

" Toggle paste mode on and off
map <leader>p :setlocal paste!<cr>

" Pressing ,ss will toggle and untoggle spell checking
map <leader>s :setlocal spell!<cr>

" Disable highlight when <leader>/ is pressed
map <silent><leader>/ :call FCVIM_ToggleHLSearch()<cr>

" 用空格键来开关折叠
nnoremap <silent> <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
nnoremap <silent> <leader><space> :call FCVIM_ToggleFoldAll()<cr>

" 光标聚焦切换
map <silent> <leader>` :call FCVIM_ToggleCursorLine()<CR>

" 制表符显示切换
map <silent> <leader><tab> :call FCVIM_ToggleList()<cr>

" 智能tab映射，保证代码前缩进为制表符，代码后则映射为空格
" inoremap <silent><tab> <c-r>=FCVIM_KeySmartTab()<cr>
" inoremap <silent><expr><tab> pumvisible() ? "\<C-n>" : FCVIM_KeySmartTab()
" inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" 在需要搜索时打开自动跳转
map / :set incsearch \| unmap /<cr>/
autocmd CmdlineLeave * set noincsearch | map / :set incsearch \| unmap /<cr>/

" 在windows终端中使用gvim的vim编辑内容可能会出现色块，利用全重绘来解决这个问题
nnoremap <silent> <F5> <Cmd>redraw!<CR>
