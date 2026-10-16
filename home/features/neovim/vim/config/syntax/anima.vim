if exists("b:current_syntax")
	finish
endif
let b:current_syn = "anima"

syn match animaApparition /\v\\[a-zA-Z0-9\-]*!?/ contains=@NoSpell
syn match animaRef /\v\$[a-zA-Z0-9\-]*!?/ contains=@NoSpell
syn match animaBuiltin /\v_[a-zA-Z0-9\-]*!?/ contains=@NoSpell
syn match animaToken /\v#[a-zA-Z0-9\-]*!?/ contains=@NoSpell
syn match animaVariant /\v- /
syn match animaPattern /\v`.*`/ contains=@NoSpell
syn match animaComment /\v;;.*$/ contains=@Spell
hi link animaApparition Keyword
hi link animaRef Type
hi link animaBuiltin Constant
hi link animaToken Special
hi link animaVariant Keyword
hi link animaPattern String
hi link animaComment Comment
