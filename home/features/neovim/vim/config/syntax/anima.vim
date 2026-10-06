if exists("b:current_syntax")
	finish
endif
let b:current_syn = "anima"

syn match animaApparition /\v\\[a-zA-Z0-9\-]*!?/ contains=@NoSpell

" https://stackoverflow.com/questions/24543887/how-to-match-rfc3339-timestamp-using-regex
syn match animaTimestamp /\v\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d(\.\d+)?[A-Z]?([+.-](\d\d:\d\d|\d\d[A-X]))?/ contains=@NoSpell
syn match animaUrl /\vhttps?:\/\/[a-zA-Z0-9%#.+/-]+/ contains=@NoSpell

hi link animaApparition Keyword
hi link animaTimestamp Special
hi link animaUrl Special
