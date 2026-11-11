if exists("b:current_syntax")
	finish
endif
runtime syntax/nihil.vim
let b:current_syn = "faimena"

syn match faimenaExpr /\v\{[a-zA-Z0-9.\-_]+\}/ contains=@NoSpell
syn match faimenaComment /;;.*$/ contains=@Spell
hi def link faimenaComment Comment

hi link faimenaExpr String
