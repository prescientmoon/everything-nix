let g:colors_name = "meow"

hi clear

" Idk why these are necessary even...
hi clear SpellBad
hi clear Visual

function! s:h(group, gui, bg, fg)
  execute "highlight" a:group
		\ "guifg=" a:fg
		\ "guibg=" a:bg
		\ "gui="   a:gui
		\ "cterm="   a:gui
endfunction

function! s:hsp(group, sp)
	execute "highlight" a:group "guisp=" a:sp
endfunction

let s:none = "NONE"
let s:italic = "italic"
let s:undercurl = "undercurl"
let s:reverse = "reverse"
let s:bold = "bold"
let s:pink0 = "#eee7e9"
let s:pink1 = "#ffdbe2"
let s:pink2 = "#b68dc3"
let s:pink3 = "#695988"
let s:gray0 = "#ffffff"
let s:gray1 = "#c0c0c0"
let s:gray2 = "#808080"
let s:gray3 = "#232323"
let s:green0 = "#e0ebe6"
let s:green1 = "#aee1cc"
let s:green2 = "#5ec39a"
let s:green3 = "#2e8b57"

call s:h("Normal",       s:none,      s:none,   s:gray3)
call s:h("StatusLine",   s:none,      s:pink1,  s:pink3)
call s:h("StatusLineNC", s:none,      s:pink1,  s:pink3)
call s:h("WildMenu",     s:none,      s:pink2,  s:pink0)
call s:h("LineNr",       s:none,      s:none,   s:pink2)
call s:h("FoldColumn",   s:none,      s:none,   s:pink2)
call s:h("Folded",       s:none,      s:pink0,  s:pink3)
call s:h("Search",       s:none,      s:pink2,  s:pink0)
call s:h("IncSearch",    s:none,      s:pink2,  s:pink0)
call s:h("Comment",      s:italic,    s:none,   s:gray2)
call s:h("Ignore",       s:italic,    s:none,   s:gray1)
call s:h("SpecialKey",   s:none,      s:none,   s:gray1)
call s:h("NonText",      s:none,      s:pink0,  s:pink0)
call s:h("ColorColumn",  s:none,      s:pink0,  s:none)
call s:h("Identifier",   s:none,      s:none,   s:gray3)
call s:h("Constant",     s:none,      s:none,   s:pink3)
call s:h("Statement",    s:bold,      s:none,   s:pink3)
call s:h("Special",      s:none,      s:none,   s:green3)
call s:h("Title",        s:bold,      s:none,   s:pink3)
call s:h("PreProc",      s:italic,    s:none,   s:green3)
call s:h("Type",         s:none,      s:none,   s:green3)
call s:h("SpellBad",     s:undercurl, s:none,   s:none)
call s:h("SpellCap",     s:undercurl, s:none,   s:none)
call s:h("Visual",       s:none,      s:green1, s:none)
call s:h("VertSplit",    s:none,      s:pink1,  s:pink1)
call s:h("Question",     s:none,      s:none,   s:green2)
call s:h("MoreMsg",      s:none,      s:none,   s:green2)
call s:h("ModeMsg",      s:none,      s:green2, s:green0)
call s:h("WarningMsg",   s:none,      s:green3, s:green0)
call s:h("ErrorMsg",     s:none,      s:pink3,  s:pink1)
call s:h("Directory",    s:none,      s:none,   s:pink3)

call s:hsp("SpellBad",   s:green3)
call s:hsp("SpellCap",   s:green3)

hi Cursor  guifg=bg   guibg=fg
hi lCursor guifg=NONE guibg=Cyan
