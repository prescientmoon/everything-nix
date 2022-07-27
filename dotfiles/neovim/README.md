# Neovim config

## Articles

- [Textobjects](https://blog.carbonfive.com/vim-text-objects-the-definitive-guide/)
- [Registers](https://www.brianstorti.com/vim-registers/)
- [Markers](https://vim.fandom.com/wiki/Using_marks)

## Keybinds

Table of my own keybinds. Here as documentation for myself. I am yet to include any of the keybinds for cmp here.

> Things written using italics are chords
> (aka all the keys need to be pressed at the same time)

| Keybind      | Description                         | Plugins            |
| ------------ | ----------------------------------- | ------------------ |
| _vs_         | Create vertical split               |                    |
| _cp_         | Use system clipboard                |                    |
| _jl_         | Save                                |                    |
| _jk_         | Exit insert mode                    |                    |
| _rw_         | Rename word under cursor            |                    |
| _\<leader>k_ | Insert digraph                      |                    |
| _\<leader>a_ | Swap last 2 used buffers            |                    |
| C-n          | Open tree                           | nvim-tree          |
| _vc_         | Clear vimux window                  | vimux              |
| _vl_         | Rerun last vimux command            | vimux              |
| _vp_         | Run command in another tmux pane    | vimux              |
| C-hjkl       | Navigation between vim & tmux panes | vim-tmux-navigator |
| J            | Show line diagnostics               | lspconfig          |
| K            | Show hover info                     | lspconfig          |
| L            | Signature help (?)                  | lspconfig          |
| gD           | Go to declaration                   | lspconfig          |
| gd           | Go to definition                    | lspconfig          |
| gi           | Go to implementation                | lspconfig          |
| \<leader>rn  | Rename                              | lspconfig          |
| \<leader>f   | format                              | lspconfig          |
| \<leader>ca  | code actions                        | lspconfig          |

### Telescope

| Keybind     | Description                    | Plugins                |
| ----------- | ------------------------------ | ---------------------- |
| Ctrl-P      | Find files                     |                        |
| Ctrl-F      | Grep in project                |                        |
| \<leader>d  | Diagnostics                    | lspconfig              |
| \<leader>ca | Code actions                   | lspconfig              |
| \<leader>t  | Show builtin pickers           |                        |
| \<leader>s  | Show symbols using tree-sitter |                        |
| \<leader>gj | List git commits               |                        |
| \<leader>gk | List git branches              |                        |
| _jp_        | Interactive file broswer       | telescope-file-browser |
| _ui_        | Insert unicode char            |                        |

### Idris

> The idris and arpeggio plugins are implicit here

| Keybind | Description         |
| ------- | ------------------- |
| _isc_   | Case split          |
| _imc_   | Make case           |
| _iml_   | Make lemma          |
| _ies_   | Expression search   |
| _igd_   | Generate definition |
| _irh_   | Refine hole         |
| _iac_   | Add clause          |

### Purescript

| Keybind | Description                                 |
| ------- | ------------------------------------------- |
| _vb_    | Make tmux run spago build in sepearate pane |
| _vt_    | Make tmux run spago test in separate pane   |

### Nix

| Keybind | Description                          |
| ------- | ------------------------------------ |
| _ug_    | Run nix-fetchgit on the current file |

### Lean

- Extra brackets: ⟨⟩

## Some cool vim keybinds I sometimes forget about

Documentation for myself

| Keybind | Description             | Plugins      |
| ------- | ----------------------- | ------------ |
| zz      | Center the current line |              |
| gcc     | Comment line            | nvim-comment |
| gc      | Comment selection       | nvim-comment |
