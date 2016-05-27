au FileType *
	    \ command! -buffer -nargs=* -complete=customlist,gensketch#CompleteRoot  GenSketch call gensketch#Call(<q-args>)

au FileType *
	    \ command! -buffer -nargs=* -complete=customlist,gensketch#CompleteRoot  GenSketchEdit call gensketch#Edit(<q-args>)
