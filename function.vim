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
    if exists('g:fcvim_loaded_function') || &compatible
        throw 'already loaded' . expand('<sfile>') . '!!!!'
    endif
catch
    finish
endtry
let g:fcvim_loaded_function = 1

"----------------------------------------------------------------------
" misc
let s:VSPosLine = 0
let s:VSPosCol = 0
let s:VSPosLine2 = 0
let s:VSPosCol2 = 0

function! FCVIM_RecordVisualSelectionPosition()
    " :echo a:firstline a:lastline
	let s:VSPosLine = line("'<")
	let s:VSPosCol = col("'<")
	let s:VSPosLine2 = line("'>")
	let s:VSPosCol2 = col("'>")
	" :echo s:VSPosLine s:VSPosLine2
    let l:pos = [0, s:VSPosLine, s:VSPosCol, 0]
    call setpos('.', l:pos)
endfunction

function! FCVIM_ClearVisualSelectionPosition()
	let s:VSPosLine = 0
	let s:VSPosCol = 0
	let s:VSPosLine2 = 0
	let s:VSPosCol2 = 0
endfunction

function! FCVIM_Menu(str)
    execute "menu Foo.Bar :" . a:str
    " emenu在新版本的vim中已经失效，需要手动调用。
    " emenu Foo.Bar
    " unmenu Foo
endfunction

function FCVIM_IsWordChar(ch)
	return stridx("1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_", a:ch) >= 0
endfunction

function FCVIM_IsUnicodeChar(ch)
    return char2nr(a:ch) > 0x7f
endfunction

function FCVIM_ContainsSymbol(str)
    for i in range(0, len(a:str) - 1)
        let l:ch = a:str[i]
        if !FCVIM_IsWordChar(l:ch) && !FCVIM_IsUnicodeChar(l:ch)
            return 1
        endif
    endfor
    return 0
endfunction

function! FCVIM_VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, '\n', '\\n', 'g')
    let l:pattern = substitute(l:pattern, '\r', '\\r', 'g')

    if !FCVIM_ContainsSymbol(@")
        let l:char = getline(line("'<"))[col("'<") - 2]
        if (!FCVIM_IsWordChar(l:char) && !FCVIM_IsUnicodeChar(l:char)) || empty(l:char)
            let l:pattern = '\<' . l:pattern
        endif

        if !FCVIM_IsUnicodeChar(getline(line("'>"))[col("'>") - 1])
            let l:char = getline(line("'>"))[col("'>")]
        else
            let l:char = getline(line("'>"))[col("'>") + 2]
        endif
        if (!FCVIM_IsWordChar(l:char) && !FCVIM_IsUnicodeChar(l:char)) || empty(l:char)
            let l:pattern = l:pattern . '\>'
        endif
    endif

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    elseif a:direction == 'g'
        call FCVIM_Menu('vimgrep ' . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'G'
        call FCVIM_Menu('vimgrep ' . '/'. l:pattern . '/ ' . expand("%"))
    elseif a:direction == 'r'
        if s:VSPosLine == 0
            call FCVIM_Menu('%s/'. l:pattern . '//g')
        else
            call FCVIM_Menu(s:VSPosLine . ',' . s:VSPosLine2 . 's/'. l:pattern . '//g')
        endif
    elseif a:direction == 'R'
        call FCVIM_Menu('cfdo %s/'. l:pattern . '//g')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! FCVIM_NormalCommand(direction)
    let l:pattern = ''
    if a:direction == 'g'
        call FCVIM_Menu('vimgrep ' . '/'. l:pattern . '/' . ' **/*.' . '<Left><Left><Left><Left><Left><Left><Left>')
    " elseif a:direction == 'G'
        " call FCVIM_Menu('vimgrep ' . '/'. l:pattern . '/ ' . expand("%"))
    elseif a:direction == 'r'
        if s:VSPosLine == 0
            call FCVIM_Menu('%s/'. l:pattern . '//g' . '<Left><Left><Left>')
        else
            call FCVIM_Menu(s:VSPosLine . ',' . s:VSPosLine2 . 's/'. l:pattern . '//g' . '<Left><Left><Left>')
        endif
    elseif a:direction == 'R'
        call FCVIM_Menu('cfdo %s/'. l:pattern . '//g' . '<Left><Left><Left>')
    endif
endfunction

"----------------------------------------------------------------------
" buffer

let s:BufValidNum = 0
let s:BufIgnoreList = [
            \'-MiniBufExplorer-',
            \'NERD_tree_1',
            \'NERD_tree_tab_1',
            \'__Tag_List__',
            \'__vista__',
            \'[YankRing]',
            \'[coc-explorer]-1',
            \'']
function! FCVIM_BufferIsValid(buf)
    let l:bufname = bufname(a:buf)
    if index(s:BufIgnoreList, l:bufname) >= 0
        return 0
    endif
    if buflisted(a:buf) == 0 || getbufvar(a:buf, "&buftype") != ""
        return 0
    endif
    return 1
endfunction

function! FCVIM_BufferNumberMap(buf)
    if FCVIM_BufferIsValid(a:buf)
        let l:bufnr = bufnr(a:buf)
        if "" == maparg('<leader>' . l:bufnr)
                    \ && "" == maparg('<leader>.' . l:bufnr)
            execute 'map <leader>' . l:bufnr . ' :buffer!' . l:bufnr . '<cr>'
            execute 'map <leader>.' . l:bufnr . ' :bwipeout!' . l:bufnr . '<cr>'
            let s:BufValidNum += 1
        endif
    endif
endfunction

function! FCVIM_BufferNumberUnmap(buf)
    let l:bufnr = bufnr(a:buf)
    if "" != maparg('<leader>' . l:bufnr)
                \ && "" != maparg('<leader>.' . l:bufnr)
        execute 'unmap <leader>' . l:bufnr
        execute 'unmap <leader>.' . l:bufnr
        let s:BufValidNum -= 1
    endif
endfunction

function! FCVIM_BufferNumberMaps()
    let l:last_bufnr = bufnr('$')
    let l:i = 0
    while l:i < l:last_bufnr
        let l:i += 1
        call FCVIM_BufferNumberMap(l:i)
    endwhile
endfunction

function! FCVIM_BufferNumberCheck(buf)
    if !FCVIM_BufferIsValid(a:buf)
        call FCVIM_BufferNumberUnmap(a:buf)
    endif
endfunction

function! FCVIM_BufferClose(buf)
    if a:buf <= 0 || a:buf > bufnr('$')
        let l:bufnr = bufnr('%')
    else
        let l:bufnr = bufnr(a:buf)
    endif

    if FCVIM_BufferIsValid(l:bufnr)
        if s:BufValidNum > 1
            execute 'bwipeout!' . l:bufnr
        else
            execute 'qa'
        endif
    else
        execute 'q'
    endif
endfunction

"----------------------------------------------------------------------
" toggle

"全局折叠开关
function! FCVIM_ToggleFoldAll()
    if &foldlevel
        execute "normal! zM"
    else
        execute "normal! zR"
    endif
endfunction

function! FCVIM_ToggleCursorLine()                   "光标聚焦切换
    if &cursorline || &cursorcolumn
        set nocursorline                " 关闭显示当前行
        set nocursorcolumn              " 关闭显示当前列
    else
        set cursorline                  " 突出显示当前行
        set cursorcolumn                " 突出显示当前列
    endif
endfunction

function! FCVIM_ToggleHLSearch()
    if &hlsearch
        set nohlsearch
    else
        set hlsearch
    endif
endfunction

" 开关制表符显示
function! FCVIM_ToggleList()
    if &list
        set nolist
    else
        set list
    endif

    if index(g:indentLine_fileTypeExclude, &filetype) == -1
        execute 'IndentLinesToggle'
    endif
endfunction

let s:QuickFix = 0
function! FCVIM_ToggleQuickFix()
    if s:QuickFix
        execute 'cclose'
        let s:QuickFix = 0
    else
        execute 'botright copen'
        let s:QuickFix = 1
    endif
endfunction

"----------------------------------------------------------------------
" command

" this is quite similar to findfile(name, '.;') fanction.
" but if find the file, we can return full name in all platform.
function! FCVIM_FindFileDirUpward(name)
    let l:key = '%:p:h'
    let l:dir = expand(l:key)
    let l:prev_dir = ''

    while isdirectory(l:dir) && l:dir != l:prev_dir
        "if filereadable(l:dir . '/' . a:name)
	if !empty(glob(l:dir . '/' . a:name))
            return l:dir
        endif

        let l:prev_dir = l:dir
        let l:key = l:key . ':h'
        let l:dir = expand(l:key)
    endwhile

    return ''
endf

function! FCVIM_EncodeConvert(str, enc)
    return iconv(a:str, 'utf-8', a:enc)
endfunction

function! FCVIM_CommandDatabaseFind(dir, fn)
    let l:tool = 'find'
    let l:files = '"' . a:dir . '/' . a:fn . '"'
    return l:tool . ' "' . a:dir . '"'
                \. ' -path ".*" -and -prune'
                \. ' -or -name "*.[chS]"'
                \. ' -or -name "*.cpp"'
                \. ' > ' . l:files
endfunction

function! FCVIM_CommandDatabaseSed(dir, fn)
        let l:tool = 'sed'
        let l:files = '"' . a:dir . '/' . a:fn . '"'
        if $FCVIM_OS == "macos"
            return l:tool . ' -i "" "s/^/\"/;s/$/\"/" ' . l:files
        else
            return l:tool . ' -i "s/^/\"/;s/$/\"/" ' . l:files
        endif
endfunction

function! FCVIM_CommandDatabaseCtags(dir, fn)
    let l:tool = 'ctags'
    let l:files = '"' . a:dir . '/' . a:fn . '"'
    let l:db =  '"' . a:dir . '/tags"'
    return l:tool . ' --tag-relative=yes'
                \. ' --c++-kinds=+px --fields=+iaS --extra=+q'
                \. ' -L ' . l:files . ' -f ' . l:db
endfunction

function! FCVIM_CommandDatabaseCscope(dir, fn)
    let l:tool = 'cscope'
    let l:files = '"' . a:dir . '/' . a:fn . '"'
    let l:db =  '"' . a:dir . '/cscope.out"'
    return l:tool . ' -bkq -i ' . l:files . ' -f ' . l:db
endfunction

function! FCVIM_Command(...)
    if has('unix')
        let l:cmd   = 'cd "' . $FCVIM_TOOLS . '"'
        let l:and   = ' && '
    else
        let l:cmd   = 'cd /d "' . $FCVIM_TOOLS . '"'
        let l:and   = ' & '
    endif

    let l:i = 0
    while l:i < a:0
        let l:cmd = l:cmd . l:and . a:000[l:i]
        let l:i += 1
    endwhile

    return FCVIM_EncodeConvert(l:cmd, 'cp936')
endfunction

function! FCVIM_DatabaseCreateAll(dir)
    let l:dir = a:dir
    if '' == l:dir
        echo 'database create current directory!!!!'
        let l:dir = expand('%:p:h')
    endif

    " disconnect databases.
    if '' != $CSCOPE_DB
        cscope kill cscope.out
    endif

    " create all databases.
    " Note: ctags files no need symbol(") to wrap path, but cscope opposite.
    echo system(FCVIM_Command(
                \FCVIM_CommandDatabaseFind(l:dir, 'db.files'),
                \FCVIM_CommandDatabaseCtags(l:dir, 'db.files'),
                \FCVIM_CommandDatabaseSed(l:dir, 'db.files'),
                \FCVIM_CommandDatabaseCscope(l:dir, 'db.files'),
                \'exit'))

    " connect databases.
    let $CSCOPE_DB = findfile('cscope.out', '.;')
    cscope add $CSCOPE_DB
endfunction

function! FCVIM_DatabaseCscopeReload(dir)
    if '' == a:dir
        echo 'cscope database reload error!!!!'
        return
    endif

    " disconnect databases.
    if '' != $CSCOPE_DB
        cscope kill cscope.out
    endif

    " copy cscope database to temp directory.
    let l:cmd = 'cp -f '
                \. fnamemodify(a:dir, ':p:8') . '/cscope.out* "'
                \. $FCVIM_TEMP . '"'
    echo system(FCVIM_Command(l:cmd))

    " connect databases.
    let $CSCOPE_DB = $FCVIM_TEMP . '/cscope.out'
    cscope add $CSCOPE_DB
endfunction

"----------------------------------------------------------------------
" comment

function! FCVIM_CommentHeadAdd(title, team, author, email)
    normal gg
    normal 16O
    call setline( 1, '/*')
    call setline( 2, ' * ' . a:title . ': ')
    call setline( 3, ' *')
    call setline( 4, ' * Copyright (C) ' . (strftime('%Y') - 1) . '-' . strftime('%Y') . ' ' . a:team . '. All rights reserved.')
    call setline( 5, ' *')
    call setline( 6, ' * Created by ' . a:author . ' <' . a:email . '>')
    call setline( 7, ' *')
    call setline( 8, ' * Please do not reproduced, distribute or quote without written')
    call setline( 9, ' * permission of the author. This software is not perfect, any')
    call setline(10, ' * problems arising from the use, have nothing to do with the author.')
    call setline(11, ' *')
    call setline(12, ' * File: ' . expand("%:t"))
    call setline(13, ' * Time: ' . strftime("%Y-%m-%d %H:%M:%S"))
    call setline(14, ' * Modified: ' . strftime("%Y-%m-%d %H:%M:%S"))
    call setline(15, ' */')
    normal 2GA
endfunction

function! FCVIM_CommentHeadKeysUpdate(max)
    silent! normal ms
    let updated = 0
    let n = 1
    "默认为添加
    while n <= a:max
	    let line = getline(n)
	    if updated == 0
		    if line =~ '^.*Copyright (C) \d\{4\}-\S*.*$'
			    let newline=substitute(line,'-\d\{4\}','-'.strftime('%Y'),'')
			    call setline(n,newline)
			    let updated = 1
		    endif
	    else
		    if line =~ '^.*File:\S*.*$'
			    let newline=substitute(line,':\(\s*\)\(\S.*$\)$',':\1'.expand("%:t"),'g')
			    call setline(n,newline)
		    elseif line =~ '^.*Modified:\S*.*$'
			    let newline=substitute(line,':\(\s*\)\(\S.*$\)$',':\1'.strftime("%Y-%m-%d %H:%M:%S"),'g')
			    call setline(n,newline)
		    endif
	    endif
	    let n = n + 1
    endwhile
    if updated == 1
        silent! normal 's
        echohl WarningMsg | echo "Succeed to update the copyright." | echohl None
    endif
    return updated
endfunction

function! FCVIM_CommentHeadUpdate(team, author, email)
	let updated = FCVIM_CommentHeadKeysUpdate(14)
	if updated == 0
		call FCVIM_CommentHeadAdd(expand("%:t"), a:team, a:author, a:email)
	endif
endfunction

"----------------------------------------------------------------------
" extension

function FCVIM_CanCompletion(ch)
	if (FCVIM_IsWordChar(a:ch))
		return v:true
	endif
	return stridx(".>/", a:ch) >= 0
endfunction

function FCVIM_StopTimer()
	if exists('g:fcvim_timer')
		call timer_stop(g:fcvim_timer)
	endif
endfunction

function FCVIM_StartTimer(timeout, callback)
	call FCVIM_StopTimer()
	:let g:fcvim_timer = timer_start(a:timeout, a:callback)
endfunction

function FCVIM_GetCurWord()
	let cword = ''
	let cur_line_str = getline('.')
	let pos = col('.')
	while pos > 0
		let pos = pos - 1
		if (!FCVIM_IsWordChar(cur_line_str[pos]))
			break
		endif
		let cword = cur_line_str[pos] . cword
	endwhile
	return cword
endfunction

function FCVIM_CompletionCallback(err, val)
	" call coc#_complete()
	" let candidates = get(g:coc#_context, 'candidates', [])
	" call insert(items, {"word": "test"})
	let items = []
	" let cword = expand("<cword>")
	let cword = FCVIM_GetCurWord()
	let cwordlen = strlen(cword)
	" echo cword
	" 候选词即使不请求也会被更新
	" echo g:coc#_context['candidates']
	let minlen = cwordlen * 100
	for item in g:coc#_context['candidates']
		if (cwordlen && stridx(item['word'], cword) == 0)
			let len = strlen(item['word'])
			if (len < minlen)
				let minlen = len
				call insert(items, item)
			else
				call add(items, item)
			endif
		endif
	endfor
	call complete(g:coc#_context.start + 1, items)
endfunction

" function FCVIM_CompletionCallbackTest(...)
	" let l:lst = {"call": '123', "call2": '234'}
	" echo extend(l:lst, get(a:, 1, {}))
" endfunction

function FCVIM_CompletionProc(timer)
	" echo col('.')
	if (FCVIM_CanCompletion(getline('.')[col('.') - 2]))
		" call FCVIM_CompletionCallbackTest({'sdf': 'qwe'})
		if (g:fcvim_completion_enable)
			" call coc#start()
			call coc#rpc#request_async('startCompletion',
						\ [coc#util#get_complete_option()],
						\ funcref('FCVIM_CompletionCallback'))
			" let g:fcvim_completion_enable = v:false
		else
			call FCVIM_CompletionCallback(v:null, v:null)
		endif
	endif
endfunction

function FCVIM_DelayCompletion()
	" call coc#_cancel()
	" if pumvisible()
		" let g:coc#_context = {'start': 0, 'preselect': -1,'candidates': []}
		" call feedkeys("\<Plug>FCVIMCocRefresh", 'i')
		" call coc#rpc#notify('stopCompletion', [])
	" endif

	call FCVIM_StartTimer(20, 'FCVIM_CompletionProc')
endfunction

function FCVIM_KeySmartTab()
    " let l:prev_char = getline('.')[col('.') - 2]
    " echo char2nr(l:prev_char)

    " if (1 == col('.') || "\<tab>" == getline('.')[col('.') - 2])
        " setlocal noexpandtab
    " else
        " setlocal expandtab
    " endif
    " return "\<tab>"

    " 此判断在vim9中失效，在外部判断可以
    " if (pumvisible())
	    " return "\<C-n>"
    " endif

    let l:cur_col = col('.')
    let l:cur_line_str = getline('.')

    " 补全控制
    " if (FCVIM_CanCompletion(l:cur_line_str[l:cur_col - 2]))
	    " " return deoplete#manual_complete(['file/include'])
	    " return coc#refresh()
    " endif

    " 制表空格
    if (1 == l:cur_col || "\<tab>" == l:cur_line_str[l:cur_col - 2])
        call feedkeys("\<tab>", 'in')
	return ''
    else
        return repeat(' ', &shiftwidth - (virtcol('.') - 1) % &shiftwidth)
    endif
endfunction

function FCVIM_KeySmartBackspace()
	" let l:cur_line = line('.')
	let l:cur_col = col('.')
	let l:cur_line_str = getline('.')
	if (l:cur_col > 2 && FCVIM_CanCompletion(l:cur_line_str[l:cur_col - 3]) &&
				\ FCVIM_CanCompletion(l:cur_line_str[l:cur_col - 2]))
		" return "\<backspace>\<tab>"
		return "\<backspace>\<c-@>"
	endif
	return "\<backspace>"
endfunction

function FCVIM_KeySmartBackspace2()
	call FCVIM_DelayCompletion()
	return "\<backspace>"
endfunction

" 初始化
function FCVIM_PluginStartupProc(timer)
	let g:fcvim_completion_enable = v:true

	" 禁用插件的补全列表刷新
	imap <expr><Plug>CocRefresh ''
	" 备用临时命令
	inoremap <silent><Plug>FCVIMCocRefresh <C-r>=coc#_complete()<CR>
endfunction

" 根据.in生成目标文件
function FCVIM_GenerateCompileFlags()
	if $FCVIM_TOOLS_CLANGD_CFLAGSDIR != ""
		if !exists('$QTROOT')
			if $FCVIM_OS == "windows"
				let $QTROOT = "C:/Qt"
			else
				if !exists('$FCHOME')
					let $QTROOT = $HOME . "/Qt"
				else
					let $QTROOT = $FCHOME . "/Qt"
				endif
			endif
		endif
		if !exists('$QTVERSION')
			let $QTVERSION = "5.15.2"
		endif
		let $QTROOT_CONV = substitute($QTROOT, "\\", "/", "g")
		let $QTROOT_CONV = substitute($QTROOT_CONV, "/", "\\\\/", "g")
		echo system(FCVIM_Command(
					\"cp -f " . $FCVIM_TOOLS_CLANGD_CFLAGSDIR . "/compile_flags.txt.in " . $FCVIM_TOOLS_CLANGD_CFLAGSDIR . "/compile_flags.txt",
					\"sed -i " . (($FCVIM_OS == "mac")?'"" ':"") . "'s/$QTROOT/" . $QTROOT_CONV . "/g; s/$QTVERSION/" . $QTVERSION . "/g' " . $FCVIM_TOOLS_CLANGD_CFLAGSDIR . "/compile_flags.txt"))
	endif
endfunction

