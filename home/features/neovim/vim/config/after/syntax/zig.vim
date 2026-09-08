" I don't want special highlighting for built-in types
hi link zigType Normal

" The core rule has been copy pasted from the zig syntax file. I removed @Spell
" from the "contains" group, such that string contents are not spell checked.
syntax region zigString matchgroup=zigStringDelimiter start=+c\?"+ skip=+\\\\\|\\"+ end=+"+ end=+$+ contains=zigEscape,zigEscapeError
