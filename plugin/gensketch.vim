command! -nargs=* -complete=customlist,gensketch#CompleteRoot  GenSketch         call gensketch#Call([<f-args>])
command! -nargs=* -complete=customlist,gensketch#CompleteRoot  GenSketchEdit     call gensketch#Edit(<q-args>)
command! -nargs=* -complete=customlist,gensketch#CompleteRoot  GenSketchHelp     call gensketch#Help(<q-args>)
command! -nargs=0                                              GenSketchUpdate   call gensketch#CompletsListUpdate()
