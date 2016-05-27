" autoload/gensketch.vim
" Sarrow: 2016-03-19
"

function gensketch#CompleteRoot(A, L, P)
    " TODO 只补全第一个参数……
    let flist = gensketch#GetCompletsList()
    call filter(flist, 'match(v:val, a:A)==0')
    return flist
endfunction

" NOTE 不定参数见：
" /usr/share/vim/vim74/doc/usr_41.txt|1034
function gensketch#Call(parameters)
    " TODO 当未提供目标名的时候，应该以当前文件夹名，为参数来提供……
    "let cmd = "genQtSketch qt/". a:root . " " . a:target . " " . l:out
    let cmd = "genQtSketch " . a:parameters
    echomsg cmd
    silent execute "!".cmd
endfunction

function gensketch#Edit(parameters)
    " TODO 当未提供目标名的时候，应该以当前文件夹名，为参数来提供……
    "let cmd = "genQtSketch qt/". a:root . " " . a:target . " " . l:out
    let path = system("genQtSketch --edit " . a:parameters)
    if len(path) > 0
        silent execute "NERDTree " . path
        echomsg "Open dir: " . a:parameters
    else
        echomsg a:parameters . " wrong parameter!"
    endif
endfunction

function gensketch#GetCompletsList()
    if exists('g:gensketchCompletList') == 0
        call gensketch#CompletsListUpdate()
    endif
    return copy(g:gensketchCompletList)
endfunction

function gensketch#CompletsListUpdate()
    let g:gensketchCompletList = split(system("genQtSketch --list"), "\n")
    " let g:gensketchCompletList = split(globpath("/home/sarrow/project/genQtSketch/template/qt", '*'), "\n")
    " call map(g:gensketchCompletList, 'fnamemodify(v:val, ":t:r")')
endfunction
