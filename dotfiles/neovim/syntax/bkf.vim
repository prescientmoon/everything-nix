if exists("b:current_syntax")
    finish
endif

echom "Our syntax highlighting code will go here."

syntax keyword kfKeyword alias template layer using
" syntax keyword kfFunction tap-macro 
syntax match kfComment "\v--.*$"

syntax match kfOperator "\v_"
syntax match kfOperator "\v\:"
syntax match kfOperator "\v\|"
syntax match kfOperator "\v\="
syntax match kfOperator "\v\=\>"
syntax match kfOperator "\v\*"
syntax match kfOperator "\v\("
syntax match kfOperator "\v\)"

syntax region kfString start=/\v"/ skip=/\v\\./ end=/\v"/

highlight link kfKeyword Keyword
" highlight link kfFunction Function
highlight link kfComment Comment
highlight link kfOperator Operator
highlight link kfString String

let b:current_syntax = "kf" 
