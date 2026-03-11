augroup filetypedetect
" We could resort to lisp for syntax highlighting, but that breaks some
" things...
au BufNewFile,BufRead *.kanata	setf kanata
augroup END
