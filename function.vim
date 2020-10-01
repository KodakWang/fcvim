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
    if exists('g:fcvim_loaded_function') || &compatible
        throw 'already loaded' . expand('<sfile>') . '!!!!'
    endif
catch
    finish
endtry
let g:fcvim_loaded_function = 1

"----------------------------------------------------------------------
" misc

" 注释函数头
function! NoteFunc()
    call setline('.','/*')
    normal o
    call setline('.','    描述：')
    let l:retl = line('.')
    normal o
    call setline('.','    参数：')
    normal o
    call setline('.','    返回：')
    normal o
    call setline('.','*/')
    exe 'normal ' .l:retl. 'G'
    startinsert!
endfunction

function! FCVIM_Menu(str)
    execute "menu Foo.Bar :" . a:str
    " emenu在新版本的vim中已经失效，需要手动调用。
    " emenu Foo.Bar
    " unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'g'
        call FCVIM_Menu('vimgrep ' . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'G'
        call FCVIM_Menu('vimgrep ' . '/'. l:pattern . '/ ' . expand("%"))
    elseif a:direction == 'replace'
        call FCVIM_Menu('%s' . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"----------------------------------------------------------------------
" buffer

let s:BufValidNum = 0
let s:BufIgnoreList = [
            \'-MiniBufExplorer-',
            \'NERD_tree_1',
            \'__Tag_List__',
            \'[YankRing]',
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
            execute 'map <leader>.' . l:bufnr . ' :MBEbw!' . l:bufnr . '<cr>'
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
            execute 'MBEbw!' . l:bufnr
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
        if filereadable(l:dir . '/' . a:name)
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
        if strlen($Apple_PubSub_Socket_Render)
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
    call setline( 4, ' * Copyright (C) 2014-' . strftime('%Y') . ' ' . a:team . '. All rights reserved.')
    call setline( 5, ' *')
    call setline( 6, ' * Created by ' . a:author . ' <' . a:email . '>')
    call setline( 7, ' *')
    call setline( 8, ' * Please do not reproduced, distribute or quote without written')
    call setline( 9, ' * permission of the author. This software is not perfect, any')
    call setline(10, ' * problems arising from the use, have nothing to do with the author.')
    call setline(11, ' *')
    call setline(12, ' * File: ' . expand("%:t"))
    call setline(13, ' * Time: ' . strftime("%Y-%m-%d %H:%M:%S"))
    call setline(14, ' * Note: ' . "FangChuang is the author's pseudonym.")
    call setline(15, ' */')
    normal 2GA
endfunction

function! FCVIM_CommentKeysUpdate(max)
    silent! normal ms
    let updated = 0
    let n = 1
    "默认为添加
    while n < a:max
        let line = getline(n)
        if line =~ '^.*Copyright (C) 2014-\S*.*$'
            let newline=substitute(line,':\(\s*\)\(\S.*$\)$',':\1'.strftime('%Y'),'g')
            call setline(n,newline)
            let updated = 1
        endif
        if line =~ '^.*File:\S*.*$'
            let newline=substitute(line,':\(\s*\)\(\S.*$\)$',':\1'.expand("%:t"),'g')
            call setline(n,newline)
            let updated = 1
        endif
        if line =~ '^.*Time:\S*.*$'
            let newline=substitute(line,':\(\s*\)\(\S.*$\)$',':\1'.strftime("%Y-%m-%d %H:%M:%S"),'g')
            call setline(n,newline)
            let updated = 1
        endif
        let n = n + 1
    endwhile
    if updated == 1
        silent! normal 's
        echohl WarningMsg | echo "Succeed to update the copyright." | echohl None
        return
    endif
    "call FCVIM_CommentHeadAdd('FCLIB', 'Kodak Wang', 'Kodak Wang', 'kodakwang@gmail.com')
endfunction

"----------------------------------------------------------------------
" key

function FCVIM_KeySmartTab(sw)
    " let l:prev_char = getline('.')[col('.') - 2]
    " echo char2nr(l:prev_char)

    " if (1 == col('.') || "\<tab>" == getline('.')[col('.') - 2])
        " setlocal noexpandtab
    " else
        " setlocal expandtab
    " endif
    " return "\<tab>"

    if (1 == col('.') || "\<tab>" == getline('.')[col('.') - 2])
        return "\<tab>"
    else
        return repeat(' ', a:sw - (virtcol('.') - 1) % a:sw)
    endif
endfunction


