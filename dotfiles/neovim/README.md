# Neovim config

## Keybinds

Table of my own keybinds. Here as documentation for myself. I am yet to include any of the keybinds for cmp here.

> Things written using italics are chords
> (aka all the keys need to be pressed at the same time)

| Keybind          | Description                                 | Plugins            |
| ---------------- | ------------------------------------------- | ------------------ |
| vv               | Create vertical split                       |                    |
| \<Space>\<Space> | Save                                        |                    |
| jj               | Exit insert mode                            |                    |
| _\<leader>k_     | Insert digraph                              |                    |
| _\<leader>a_     | Swap last 2 used buffers                    |                    |
| C-n              | Open tree                                   | nvim-tree          |
| _vp_             | Run command in another tmux pane            | vimux              |
| _sk_             | Move to previous lh-bracket marker          | lh-brackets        |
| _sj_             | Move to next lh-bracket marker              | lh-brackets        |
| _mo_             | Move outside the current brackets           | lh-brackets        |
| _ml_             | Remove all markers and move to the last one | lh-brackets        |
| C-hjkl           | Navigation between vim & tmux panes         | vim-tmux-navigator |
| J                | Show line diagnostics                       | lspconfig          |
| K                | Show hover info                             | lspconfig          |
| L                | Signature help (?)                          | lspconfig          |
| gD               | Go to declaration                           | lspconfig          |
| gd               | Go to definition                            | lspconfig          |
| gi               | Go to implementation                        | lspconfig          |
| \<leader>rn      | Rename                                      | lspconfig          |
| \<leader>f       | format                                      | lspconfig          |

### Lh-brackets

The default brackets I load in each buffer are (), [], "", '', {} and \`\`. Different brackets are added in different filetypes.

### Telescope

| Keybind     | Description                    | Plugins                |
| ----------- | ------------------------------ | ---------------------- |
| Ctrl-P      | Find files                     |                        |
| Ctrl-F      | Grep in project                |                        |
| \<leader>d  | Diagnostics                    | lspconfig              |
| \<leader>wd | Workspace diagnostics          | lspconfig              |
| \<leader>ca | Code actions                   | lspconfig              |
| \<leader>t  | Show builtin pickers           |                        |
| \<leader>s  | Show symbols using tree-sitter |                        |
| \<leader>gj | List git commits               |                        |
| \<leader>gk | List git branches              |                        |
| \<leader>p  | Interactive file broswer       | telescope-file-browser |
| _ui_        | Insert unicode char            |                        |

### Idris

> The idris and arpeggio plugins are implicit here

| Keybind | Description         |
| ------- | ------------------- |
| _sc_    | Case split          |
| _mc_    | Make case           |
| _ml_    | Make lemma          |
| _es_    | Expression search   |
| _gd_    | Generate definition |
| _rh_    | Refine hole         |
| _ac_    | Add clause          |

### Lean

- Extra brackets: ⟨⟩

## Some cool vim keybinds I sometimes forget about

Documentation for myself

| Keybind | Description             | Plugins      |
| ------- | ----------------------- | ------------ |
| zz      | Center the current line |              |
| gcc     | Comment line            | nvim-comment |
| gc      | Comment selection       | nvim-comment |
