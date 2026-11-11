augroup filetypedetect
au BufNewFile,BufRead .gitignore,*.git/info/exclude setf gitignore
augroup END
