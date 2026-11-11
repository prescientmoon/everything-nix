if exists("b:current_syntax")
	finish
endif
let b:current_syn = "nihil"

syn match nihilApparition /\v\\[a-zA-Z0-9\-]*!?/ contains=@NoSpell

" https://stackoverflow.com/questions/24543887/how-to-match-rfc3339-timestamp-using-regex
syn match nihilTimestamp /\v\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d(\.\d+)?[A-Z]?([+.-](\d\d:\d\d|\d\d[A-X]))?/ contains=@NoSpell
syn match nihilUrl /\vhttps?:\/\/[a-zA-Z0-9%#.+/-]+/ contains=@NoSpell

hi link nihilApparition Keyword
hi link nihilTimestamp Special
hi link nihilUrl Special
