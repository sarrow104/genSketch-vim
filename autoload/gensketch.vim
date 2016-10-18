" autoload/gensketch.vim
" Sarrow: 2016-03-19
"
" /usr/local/vim8/share/vim/vim80/doc/map.txt:1306
" function {func}(ArgLead, CmdLine, CursorPos)
" The function arguments are:
" 	ArgLead		the leading portion of the argument currently being
" 			completed on
" 	CmdLine		the entire command line
" 	CursorPos	the cursor position in it (byte index)
" :command 的补全，对于用户来说，实际关心的是如下信息：
" 首先，假设，该命令行的参数列表，可以按空格，划分为多个参数。
"   1. 已经输入完毕的参数列表
"   2. 当前正在输入的参数的前导字符——可为空串
"   3. 当前输入位置，后续字符是否是空格——即，语义上，当前位置，是否切分了一个参数？
function gensketch#CommandHelpComplete(ArgLead, CmdLine, CursorPos)
    let l:pre_args = <SID>GetPreCommandArgs(a:ArgLead, a:CmdLine, a:CursorPos)
    if empty(l:pre_args)
        return <SID>GenMatchedTemplateName(a:ArgLead)
    else
        return []
    endif
endfunction

function s:GetPreCommandArgs(ArgLead, CmdLine, CursorPos)
    let l:pre_cmd=a:CmdLine[0:a:CursorPos-len(a:ArgLead)-1]
    let l:pre_cmd=substitute(l:pre_cmd, '\s*$', '', 'g')
    let l:pre_cmd=split(l:pre_cmd, ' \+')[1:]
    " filter-out -Dname=value option command
    call filter(l:pre_cmd, 'match(v:val, "-D")!=0')
    return l:pre_cmd
endfunction

" use template-name
function gensketch#CommandGenComplete(ArgLead, CmdLine, CursorPos)
    let l:pre_args = <SID>GetPreCommandArgs(a:ArgLead, a:CmdLine, a:CursorPos)
    if empty(l:pre_args)
        return <SID>GenMatchedTemplateName(a:ArgLead)
    elseif len(l:pre_args) == 1
        return []
    elseif len(l:pre_args) == 2
        return <SID>GenPathList(a:ArgLead)
    else
        let l:option_list = ['-D']
        call filter(l:option_list, 'match(v:val, a:ArgLead)==0')
        return l:option_list
    endif
endfunction

" edit template-name
function gensketch#CommandEditComplete(ArgLead, CmdLine, CursorPos)
    let l:pre_args = <SID>GetPreCommandArgs(a:ArgLead, a:CmdLine, a:CursorPos)
    if len(l:pre_args) <= 1
        return <SID>GenMatchedTemplateName(a:ArgLead)
    else
        return []
    endif
endfunction

function s:GenMatchedTemplateName(ArgLead)
    let l:flist = gensketch#GetCompletsList()
    call filter(l:flist, 'match(v:val, a:ArgLead)==0')
    return flist
endfunction

function s:GenPathList(ArgLead)
    let l:flist = split(globpath('.', a:ArgLead.'*/*'), "\n")
    " remove leading './'
    call map(l:flist, 'v:val[2:]')
    return l:flist
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
    call <SID>FocusFile(default_file)
endfunction

function s:FocusFile(fname)
    if filereadable(a:fname)
        silent execute "edit " . fnameescape(a:fname)
        if exists(":NERDTree")
            " NOTE: 切分窗口之后，winnr要变化，因此稳妥的办法，是记录bufnr()
            " bufnr('%')
            let n = bufnr('%')
            silent execute 'NERDTreeFocus'
            " NERDtree并没有refesh-root的接口；
            " 我这里是强制刷新
            bd
            silent execute 'NERDTreeFind'
            silent execute bufwinnr(n) . 'wincmd w'
        endif
    endif
endfunction

function gensketch#Edit(parameters)
    " TODO 当未提供目标名的时候，应该以当前文件夹名，为参数来提供……
    "let cmd = "genSketch qt/". a:root . " " . a:target . " " . l:out
    let path = system("genSketch --edit " . a:parameters)
    if len(path) > 0
        if exists(":NERDTree")
            silent execute 'NERDTree ' . fnameescape(path)
        else
            silent execute 'e ' . fnameescape(path)
        endif
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

