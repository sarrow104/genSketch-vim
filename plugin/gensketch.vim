" 这个需要补全样式为：模板名，工程名（无补全），相对路径
command! -nargs=* -complete=customlist,gensketch#CommandGenComplete     Sketch         call gensketch#Call([<f-args>])
" 这个需要补全样式为：模板名，[模板名]
command! -nargs=* -complete=customlist,gensketch#CommandEditComplete    SketchEdit     call gensketch#Edit(<q-args>)
" 这个需要补全样式为：模板名
command! -nargs=* -complete=customlist,gensketch#CommandHelpComplete    SketchHelp     call gensketch#Help(<q-args>)
command! -nargs=0                                                       SketchUpdate   call gensketch#CompletsListUpdate()
