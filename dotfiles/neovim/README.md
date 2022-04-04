# Neovim config

## Keybinds

Table of my own keybinds. Here as documentation for myself. I am yet to include any of the keybinds for the lspconfig, telescope or cmp here.

> Things written using italics are chords
> (aka all the keys need to be pressed at the same time)

| Keybind          | Description                                 | Plugins            |
| ---------------- | ------------------------------------------- | ------------------ |
| vv               | Create vertical split                       |                    |
| \<Space>\<Space> | Save                                        |                    |
| jj               | Exit insert mode                            |                    |
| C-n              | Open tree                                   | nvim-tree          |
| _vp_             | Run command in another tmux pane            | vimux, arpeggio    |
| _<leader>k_      | Insert digraph                              |                    |
| _<leader>a_      | Swap last 2 used buffers                    |                    |
| _sk_             | Move to previous lh-bracket marker          | lh-brackets        |
| _sj_             | Move to next lh-bracket marker              | lh-brackets        |
| _mo_             | Move outside the current brackets           | lh-brackets        |
| _ml_             | Remove all markers and move to the last one | lh-brackets        |
| C-hjkl           | Navigation between vim & tmux panes         | vim-tmux-navigator |

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
