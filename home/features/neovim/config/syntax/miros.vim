" if exists("b:current_syntax")
"     finish
" endif

set iskeyword+=-


syn match mirosComment "\v--.*$"
hi link mirosComment Comment

syn match mirosName /\v\@\h\w*/ contained
syn match mirosLiteral /\v.+/ contained contains=mirosName,mirosArray oneline
hi link mirosLiteral mirosString

syn match mirosFor /\vfor\s+\w+\s+\<-\s+/ nextgroup=mirosArray
syn match mirosForName /\vfor\s+\w+\s+/ contained containedin=mirosFor
hi link mirosForName mirosName
syn match mirosKeyword /\vfor/ contained containedin=mirosForName
syn match mirosOperator "\v\<\-" contained containedin=mirosFor

syn match mirosBlock /\v^\s*block(\s+(auto|!?(start|math)))*/
syn match mirosKeyword /\vblock/ contained containedin=mirosBlock
syn match mirosBlockContext /\v(auto|start|math)/ contained containedin=mirosBlock
hi link mirosBlockContext Constant
syn match mirosOperator /\v!/ contained containedin=mirosBlock

syn match mirosDecl /\v^\s*(desc|name|string|pattern)\s+/ nextgroup=mirosLiteral
syn match mirosKeyword /\v(desc|name|string|pattern)/ contained containedin=mirosDecl

syn match mirosDecl /\v^\s*postfix(\s+|$)/ nextgroup=mirosLiteral
syn match mirosKeyword /\vpostfix/ contained containedin=mirosDecl

syn region mirosArray matchgroup=mirosArrayBraces start=/\v\@\{/ skip=/\v\\\\|\\}/ end=/\v\}/ contained contains=mirosName,mirosArray,mirosTabStop,mirosNonempty,mirosNeEscape,mirosCapture,mirosChoice,mirosCall
hi link mirosArrayBraces mirosOperator
syn match mirosArrayMap /\v\@\w+:/ contained containedin=mirosArray contains=mirosName
syn match mirosArrayColon /\v:/ contained containedin=mirosArrayMap
hi link mirosArrayColon mirosOperator

syn region mirosShortSnipDecl matchgroup=mirosKeyword start=/\v^\s*snip\s+/ end=/\v$/ contains=mirosName,mirosArray,mirosTabstop,mirosNonempty,mirosNeEscape,mirosCapture,mirosChoice,mirosCall
syn region mirosLongSnipDecl matchgroup=mirosKeyword start=/\v^\s*snip\s*$/ end=/\v^\s*end/  contains=mirosName,mirosArray,mirosTabstop,mirosNonempty,mirosNeEscape,mirosCapture,mirosChoice,mirosCall

syn match mirosTabStop /\v\$\d/ contained
hi link mirosTabStop mirosOperator

syn region mirosNonempty start=/\v\$\?\d\{/ matchgroup=mirosOperator skip=/\v\\\\|\\}/ end=/\v\}/ contained contains=mirosName,mirosArray,mirosTabStop,mirosNonempty,mirosNeEscape,mirosCapture,mirosChoice,mirosCall
syn match mirosNonemptyDelim /\v\$\?\d\{/ contained containedin=mirosNonempty
hi link mirosNonemptyDelim mirosOperator

syn region mirosNeEscape matchgroup=mirosOperator start=/\v\@\^\{/ skip=/\v\\\\|\\}/ end=/\v\}/ contained contains=mirosName,mirosArray,mirosTabStop,mirosNonempty,mirosNeEscape,mirosCapture,mirosChoice

syn match mirosCapture /\v\@\d/ contained
hi link mirosCapture mirosOperator
syn match mirosNumber /\v\d/ contained containedin=mirosCapture

syn region mirosChoice start=/\v\$\|\d\{/ matchgroup=mirosOperator  skip=/\v\\\\|\\}/ end=/\v\}/ contained contains=mirosName,mirosArray,mirosTabStop,mirosNonempty,mirosNeEscape,mirosCapture,mirosChoice,mirosCall
syn match mirosChoiceDelim /\v\$\|\d\{/ contained containedin=mirosChoice
hi link mirosChoiceDelim mirosOperator

syn region mirosCall start=/@:\w\+(/ skip=/\v\\\\|\\\)/ matchgroup=mirosOperator end=')' contained contains=mirosName,mirosArray,mirosTabStop,mirosNonempty,mirosNeEscape,mirosCapture,mirosChoice,mirosCall
syn match mirosCallStart /\v\@:\w+/ contained containedin=mirosCall
hi link mirosCallStart mirosOperator
syn match mirosCallFunc /\v\w+/ contained containedin=mirosCallStart
hi link mirosCallFunc mirosName
syn match mirosOperator /(/ contained containedin=mirosCall

syn match mirosNumber /\v\d/ contained containedin=mirosNonemptyDelim,mirosTabStop,mirosChoiceDelim
syn match mirosComma /\v,/ contained containedin=mirosArray,mirosChoice
hi link mirosComma mirosOperator

hi link mirosString String
hi link mirosOperator Operator
hi link mirosFunction Function
hi link mirosKeyword Keyword
hi link mirosName Identifier
hi link mirosNumber Number

let b:current_syn = "miros"
