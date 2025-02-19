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

let $FCVIM = expand('<sfile>:p:h') . '/fcvim'
if !isdirectory($FCVIM) "finddir($FCVIM) == ''
    if has('win32unix')
        let $FCVIM = substitute($USERPROFILE, ':', '', '')
        let $FCVIM = '/' . substitute($FCVIM, '\\', '/', 'g') . '/Documents/projects/fcvim'
    elseif has('win32')
        let $FCVIM = substitute($USERPROFILE, '\\', '/', 'g') . '/Documents/projects/fcvim'
    else
        let $FCVIM = expand('<sfile>:p:h') . '/projects/fcvim'
    endif
endif
source $FCVIM/entry.vim

