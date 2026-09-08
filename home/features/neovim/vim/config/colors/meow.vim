" My custom Vim color scheme :3
" Mostly pink / purple, with some green accents!
let g:colors_name = "meow"

hi clear

" Idk why these are necessary even...
hi clear SpellBad
hi clear SpellCap
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

" This is the palette I came up with in Aseprite. Some of the colours might
" not see much use (if any).
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

" This is here such that the alignment looks more aesthetically pleasing.
let s:none = "NONE"

call s:h("Normal",       "none",      s:none,   s:gray3)
call s:h("StatusLine",   "none",      s:pink1,  s:pink3)
call s:h("StatusLineNC", "none",      s:pink1,  s:pink3)
call s:h("WildMenu",     "none",      s:pink2,  s:pink0)
call s:h("LineNr",       "none",      s:none,   s:pink2)
call s:h("FoldColumn",   "none",      s:none,   s:pink2)
call s:h("Folded",       "none",      s:pink0,  s:pink3)
call s:h("Search",       "none",      s:pink2,  s:pink0)
call s:h("IncSearch",    "none",      s:pink2,  s:pink0)
call s:h("Comment",      "italic",    s:none,   s:gray2)
call s:h("Ignore",       "italic",    s:none,   s:gray1)
call s:h("SpecialKey",   "none",      s:none,   s:gray1)
call s:h("NonText",      "none",      s:green0,  s:green0)
call s:h("ColorColumn",  "none",      s:pink0,  s:none)
call s:h("Title",        "bold",      s:none,   s:pink3)
call s:h("SpellBad",     "undercurl", s:none,   s:none)
call s:h("Visual",       "none",      s:green1, s:none)
call s:h("MatchParen",   "none",      s:green1, s:none)
call s:h("VertSplit",    "none",      s:pink1,  s:pink1)
call s:h("Question",     "none",      s:none,   s:green2)
call s:h("MoreMsg",      "none",      s:none,   s:green2)
call s:h("ModeMsg",      "none",      s:green2, s:green0)
call s:h("WarningMsg",   "none",      s:green3, s:green0)
call s:h("ErrorMsg",     "none",      s:pink3,  s:pink1)
call s:h("Directory",    "none",      s:none,   s:pink3)
call s:h("Todo",         "none",      s:green2, s:green0)
call s:h("Identifier",   "none",      s:none,   s:gray3)
call s:h("Constant",     "none",      s:none,   s:pink3)
call s:h("Statement",    "bold",      s:none,   s:pink3)
call s:h("PreProc",      "none",      s:none,   s:pink3)
call s:h("StorageClass", "bold",      s:none,   s:pink3)
call s:h("Type",         "none",      s:none,   s:pink3)
call s:h("Special",      "none",      s:none,   s:green3)

call s:hsp("SpellBad",   s:green3)
call s:hsp("SpellCap",   s:green3)

hi Cursor  guifg=bg   guibg=fg
hi lCursor guifg=NONE guibg=Cyan
