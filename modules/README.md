# Modules

This directory contains custom module definitions used throughout my config.

## File structure

| Directory                      | Description                                                    |
| ------------------------------ | -------------------------------------------------------------- |
| [common](./common)             | Modules usable in both HM and nixos (and perhaps other places) |
| [nixos](./nixos)               | Nixos specific functionality                                   |
| [home-manager](./home-manager) | Home manager specific functionality                            |

## Common modules

| Name                                            | Attribute                   | Description                                                                                   |
| ----------------------------------------------- | --------------------------- | --------------------------------------------------------------------------------------------- |
| [toggles](./common/toggles.nix)                 | `satellite.toggles`         | Generic interface for feature flags                                                           |
| [lua-lib](./common/lua-lib.nix)                 | `satellite.lib.lua`         | Helpers for working with lua code                                                             |
| [korora-lua](./common/korora-lua.nix)           | -                           | Nix -> lua encoder typechecked using [korora](https://github.com/adisbladis/korora)           |
| [korora-neovim](./common/korora-neovim.nix)     | -                           | Nix -> neovim config helpers typechecked using [korora](https://github.com/adisbladis/korora) |
| [theming](./common/theming.nix)                 | `satellite.theming`         | [stylix](https://github.com/danth/stylix) theming helpers and configuration                   |
| [lua-colorscheme](./common/lua-colorscheme.nix) | `satellite.colorscheme.lua` | Base16 theme to lua module generation                                                         |
| [octodns](./common/octodns.nix)                 | `satellite.dns.octodns`     | Octodns config generation                                                                     |
