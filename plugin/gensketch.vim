" 这个需要补全样式为：模板名，工程名（无补全），相对路径
command! -nargs=* -complete=customlist,gensketch#CommandGenComplete     GenSketch         call gensketch#Call([<f-args>])
" 这个需要补全样式为：模板名，[模板名]
command! -nargs=* -complete=customlist,gensketch#CommandEditComplete    GenSketchEdit     call gensketch#Edit(<q-args>)
" 这个需要补全样式为：模板名
command! -nargs=* -complete=customlist,gensketch#CommandHelpComplete    GenSketchHelp     call gensketch#Help(<q-args>)
command! -nargs=0                                                       GenSketchUpdate   call gensketch#CompletsListUpdate()
