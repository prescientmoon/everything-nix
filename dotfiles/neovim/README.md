# Neovim config

## Articles

- [Textobjects](https://blog.carbonfive.com/vim-text-objects-the-definitive-guide/)
- [Registers](https://www.brianstorti.com/vim-registers/)
- [Markers](https://vim.fandom.com/wiki/Using_marks)

## Keybinds

I feel like macro recording is a rare thing, so I moved it to `yq/yQ`. This frees up `q` as a "namespace" of sorts for other default vim keybinds I want to move out. For example, I use `J` for diagnostics, so I moved the default action from `J` to `qj`.

> Things written using italics are chords
> (aka all the keys need to be pressed at the same time)

### Base

| Keybind     | Description                                      | Plugins |
| ----------- | ------------------------------------------------ | ------- |
| \<leader>a  | [A]lternate file                                 |         |
| \<leader>rw | [R]eplace [w]ord under cursor in the entire file |         |
| Q           | [Q]uit all buffers                               |         |
| [d          | Previous [d]iagnostic                            |         |
| d]          | Next [d]iagnostic                                |         |
| J           | Hover over diagnostic                            |         |
| yq          | Merge with next line                             |         |
| \<leader>D  | [D]iagnostic loclist                             |         |
| _jk_        | Exit insert mode                                 |         |
| _jo_        | Save file                                        |         |
| S-Enter     | Newline without continuing comment               |         |

### Textobjects

| Keybinds | Description                | Plugins |
| -------- | -------------------------- | ------- |
| aq       | [A]round [q]uotes          |         |
| iq       | [I]nside [q]uotes          |         |
| aa       | [A]round [a]phostrophes    |         |
| ia       | [I]nside [a]phostrophes    |         |
| ar       | [A]round squa[r]e brackets |         |
| ir       | [I]nside squa[r]e brackets |         |

### Treesitter

| Keybinds | Description                     |
| -------- | ------------------------------- |
| ]f       | Go to next [f]unction start     |
| ]F       | Go to next [f]unction end       |
| [f       | Go to previous [f]unction start |
| [F       | Go to previous [f]unction end   |
| ]c       | Go to next [c]lass start        |
| ]C       | Go to next [c]lass end          |
| [c       | Go to previous [c]lass start    |
| [C       | Go to previous [c]lass end      |

#### Textobjects

| Keybinds | Description         |
| -------- | ------------------- |
| af       | [A]round [f]unction |
| if       | [I]nside [f]unction |
| ac       | [A]round [c]lass    |
| ic       | [I]nside [c]lass    |

### Telescope

The `<leader>f` namespace contains keybinds which search for a specific filetype.

| Keybind     | Description          | Plugins   |
| ----------- | -------------------- | --------- |
| C-p         | Find files           |           |
| C-f         | Grep in project      |           |
| \<leader>d  | Diagnostics          | lspconfig |
| \<leader>t  | Show builtin pickers |           |
| \<leader>ft | Typescript Files     |           |
| \<leader>fl | Latex Files          |           |
| \<leader>fp | Purescript Files     |           |
| \<leader>fn | Nix Files            |           |

### Cmp

| Keybind | Description              |
| ------- | ------------------------ |
| C-d     | Scroll completion up     |
| C-s     | Scroll completion down   |
| Enter   | Accept current competion |

### Lsp

The lsp configuration introduces the namespace `<leader>w` used for workspace manipulation.

| Keybind     | Description                 |
| ----------- | --------------------------- |
| gd          | [G]o to [d]efinition        |
| gr          | [G]o to [r]eferences        |
| gi          | [G]o to [i]mplementation    |
| K           | Hover                       |
| L           | Signature help              |
| \<leader>c  | [C]ode actions              |
| \<leader>F  | [F]ormat file               |
| \<leader>li | [l]sp [i]nfo                |
| \<leader>rn | [R]e[n]ame                  |
| \<leader>wa | [W]orkspace [a]dd folder    |
| \<leader>wr | [W]orkspace [r]emove folder |
| \<leader>wl | [W]orkspace [l]ist folders  |

### Vimux

Vimux keybinds live in the `<leader>v` namespace. Most vimux keybinds are filetype specific.

| Keybind     | Description                |
| ----------- | -------------------------- |
| \<leader>vc | [V]imux clear              |
| \<leader>vl | [V]imux rerun last         |
| \<leader>vp | [V]imux prompt for command |

### Luasnip

| Keybind     | Description                  |
| ----------- | ---------------------------- |
| Tab         | Jump to next placeholder     |
| S-Tab       | Jump to previous placeholder |
| \<leader>rs | [R]eload [s]nippets          |

### Filetypes

General filetype local keybinds reside inside the `<leader>l` namespace.

#### Purescript

| Keybind     | Description               |
| ----------- | ------------------------- |
| \<leader>vb | [V]imux run spago [b]uild |
| \<leader>vt | [V]imux run spago [t]est  |

#### Nix

| Keybind     | Description              |
| ----------- | ------------------------ |
| \<leader>lg | Update [g]it fetch calls |

#### Idris

Idris keybinds live in the `<leader>I` namespace.

| Keybind     | Description         |
| ----------- | ------------------- |
| \<leader>IC | Make [c]ase         |
| \<leader>IL | Make [l]emma        |
| \<leader>Ic | Add [c]lause        |
| \<leader>Ie | [E]xpression search |
| \<leader>Id | Generate [d]ef      |
| \<leader>Is | [S]plit case        |
| \<leader>Ih | Refine [h]ole       |

#### Lua

| Keybind     | Description                       |
| ----------- | --------------------------------- |
| \<leader>lf | Run [f]ile                        |
| \<leader>ls | Import [f]ile and call .[s]etup() |

### Hydra

| Keybind    | Description         |
| ---------- | ------------------- |
| C-W        | Enter [w]indow mode |
| \<leader>v | Enter [v]enn mode   |

#### Window mode

| Keybind   | Description                              |
| --------- | ---------------------------------------- |
| h/j/k/l   | Move cursor by window in given direction |
| H/J/K/L   | Move window in given direction           |
| C-h/j/k/l | Resize window in given direction         |
| =         | Equalize                                 |
| s         | Split horizontally                       |
| v         | Split vertically                         |
| o         | Close all other                          |
| q         | Close window                             |

#### Venn mode

| Keybind | Description                       |
| ------- | --------------------------------- |
| H/J/K/L | Continue arrow in given direction |
| f       | Surround selected region with box |

### Firenvim

The following keybinds are available only when running inside firenvim:

| Keybind | Description   |
| ------- | ------------- |
| C-z     | Expand window |

### Small plugin keybinds

| Keybind               | Description                         | Plugins              |
| --------------------- | ----------------------------------- | -------------------- |
| gcc                   | Comment line                        | nvim-comment         |
| gc                    | Comment selection                   | nvim-comment         |
| C-g                   | Open neo[g]it                       | neogit               |
| \<leader>yg           | [Y]ank remote [g]it url             | gitlinker            |
| <tab>r[a][b]          | Change surrounding pair from a to b | mini.surround        |
| <tab>d[a]             | Delete surrounding pair of a        | mini.surround        |
| <tab>s[m][a]          | Surround the motion m with a        | mini.surround        |
| <tab>s[a]             | Surround selected code with a       | mini.surround        |
| C-F                   | Interactive file broswer            | mini.files           |
| s                     | Flash [s]earch                      | flash                |
| S                     | Flash treesitter [s]elect           | flash                |
| r                     | remote [f]lash                      | flash                |
| R                     | remote treesitter [f]lash           | flash                |
| C-s                   | Toggle flash [s]earch               | flash                |
| C-n                   | Open filetree                       | nvim-tree            |
| \<leader>p            | [P]aste imge from clipboard         | clipboard-image.nvim |
| \<leader>L            | [L]azy ui                           | lazy.nvim            |
| C-h/j/k/l             | Navigate panes                      | vim-tmux-navigator   |
| \<leader\>h           | Add file to harpoon                 | harpoon              |
| C-a                   | Harpoon quick menu                  | harpoon              |
| C-s q/w/e/r/a/s/d/f/z | Open harpoon file with index 0-9    | harpoon              |
| <leader>lc            | Open [l]ocal [c]argo.toml           | rust-tools           |

### Undocumented

#### Iron.nvim

Iron.nvim commands rest in the `<leader>i` namespace. There is a lot of them, and I rarely use this plugin, so I won't document them here just yet.

#### Magma

Magma commands live under the namespace `<leader>M`. I barely use this plugin, so I won't document my keybinds just yet.
