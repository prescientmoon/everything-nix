if exists('b:current_syntax')
	finish
endif
let b:current_syntax = 'gitignore'

syn match gitignoreComment /^#.*/
hi def link gitignoreComment Comment
