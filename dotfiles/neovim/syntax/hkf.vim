if exists("b:current_syntax")
    finish
endif

syntax keyword kfKeyword alias template layer using path name input output assume fun as import exporting module unsafe def
syntax keyword kfFunction LayerTemplate Sequence Chord Keycode Layer Broken

syntax match kfComment "\v--.*$"

syntax match kfOperator "\v_"
syntax match kfOperator "\v\,"
syntax match kfOperator "\v\."
syntax match kfOperator "\v\:"
syntax match kfOperator "\v\|"
syntax match kfOperator "\v\="
syntax match kfOperator "\v\=\>"
syntax match kfOperator "\v\-\>"
syntax match kfOperator "\v→"
syntax match kfOperator "\v\*"
syntax match kfOperator "\v\("
syntax match kfOperator "\v\)"
syntax match kfOperator "\vλ"

syntax region kfString start=/\v"/ skip=/\v\\./ end=/\v"/

highlight link kfKeyword Keyword
highlight link kfFunction Function
highlight link kfComment Comment
highlight link kfOperator Operator
highlight link kfString String

let b:current_syntax = "hkf" 
