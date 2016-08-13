" autoload/gensketch.vim
" Sarrow: 2016-03-19
"

function gensketch#CompleteRoot(A, L, P)
    " TODO 只补全第一个参数……
    let flist = gensketch#GetCompletsList()
    call filter(flist, 'match(v:val, a:A)==0')
    return flist
endfunction

" NOTE: 不定参数见：
" /usr/share/vim/vim74/doc/usr_41.txt|1034
function gensketch#Call(parameters)
    " TODO 当未提供目标名的时候，应该以当前文件夹名，为参数来提供……
    let cmd = "genSketch " . join(a:parameters, ' ')
    echomsg cmd
    let outputs = system(cmd)
    let default_file = ""
    for line in split(outputs, "\n")
        if line =~ "^default-file="
            let default_file = strpart(line, 13)
            break
        endif
    endfor
    if filereadable(default_file)
        silent execute "edit " . fnameescape(default_file)
        if len(a:parameters) >= 3
            silent execute "NERDTree " . fnameescape(a:parameters[2])
        endif
    endif
endfunction

function gensketch#Edit(parameters)
    " TODO 当未提供目标名的时候，应该以当前文件夹名，为参数来提供……
    "let cmd = "genSketch qt/". a:root . " " . a:target . " " . l:out
    let path = system("genSketch --edit " . a:parameters)
    let dir_cmd = "e"
    if exists(":NERDTree") > 0
        let dir_cmd = "NERDTree"
    endif
    if len(path) > 0
        silent execute dir_cmd . path
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
    let g:gensketchCompletList = split(system("genSketch --list"), "\n")
endfunction

function gensketch#Help(parameters)
    " NOTE
    " 新开一个buffer，并将帮助文档，设置为md风格，并显示出来。
    " NOTE new 的时候，附带名字，即可设置buffer的名字；
    " 暂时使用空白……
    if !bufexists('gensketchHelp')
        new gensketchHelp
    else
	exe bufwinnr(bufnr('gensketchHelp')).'wincmd w'
    endif
    setfiletype markdown
    setlocal modifiable
    silent %delete _
    let content = split(system("genSketch --help " . a:parameters), '\n')
    silent 0put = content
    let &modified=0
    setlocal nomodifiable
endfunction

