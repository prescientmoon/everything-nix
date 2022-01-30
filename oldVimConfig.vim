" Rebind esc to pressing j twice
:imap jj <Esc>

" Indentation stuff
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab

" Line numbers
:set relativenumber
:set rnu


" Plugins
call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex'

" Autocompletion engine
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" A Vim Plugin for Lively Previewing LaTeX PDF Output
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

Plug 'jiangmiao/auto-pairs'

call plug#end()

" ========== Latext setup
" Activate deoplete
let g:deoplete#enable_at_startup = 1

" Minimum character length needed to activate auto-completion.
call deoplete#custom#option('min_pattern_length', 1)

" use fuzzy matcher
call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])

" Latex autocompletion
call deoplete#custom#var('omni', 'input_patterns', {
    \ 'tex': g:vimtex#re#deoplete
    \})

let g:latex_view_general_viewer = "zathura"
let g:vimtex_view_method = "zathura"

au FileType tex let b:AutoPairs = AutoPairsDefine({'$' : '$'}, [])

let g:vimtex_compiler_progname = 'nvr'

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
