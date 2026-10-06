if exists("b:current_syntax")
	finish
endif
runtime syntax/anima.vim
let b:current_syn = "anima"

syn match faimenaExpr /\v\{[a-zA-Z0-9.\-_]+\}/ contains=@NoSpell
syn match faimenaComment /;;.*$/ contains=@Spell
hi def link faimenaComment Comment

hi link faimenaExpr String
