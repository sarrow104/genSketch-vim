command -buffer -nargs=* -complete=customlist,gensketch#CompleteRoot  GenSketch         call gensketch#Call(<q-args>)
command -buffer -nargs=* -complete=customlist,gensketch#CompleteRoot  GenSketchEdit     call gensketch#Edit(<q-args>)
command -buffer -nargs=* -complete=customlist,gensketch#CompleteRoot  GenSketchHelp     call gensketch#Help(<q-args>)
command -buffer -nargs=0                                              GenSketchUpdate   call gensketch#CompletsListUpdate()
