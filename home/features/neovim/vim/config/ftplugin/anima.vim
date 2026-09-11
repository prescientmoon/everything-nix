set iskeyword=a-z,A-Z,48-57,.,\

" We avoid :r! because that inserts a leading newline. We similarly use [:-2]
" to cut the trailing newline that system(...) always inserts.
inoreabbrev <buffer> .now <C-r>=system("date --iso-8601=seconds")[:-2]<cr>
