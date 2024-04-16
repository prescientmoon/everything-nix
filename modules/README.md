# Modules

This directory contains custom module definitions used throughout my config.

## File structure

| Directory                      | Description                                                    |
| ------------------------------ | -------------------------------------------------------------- |
| [common](./common)             | Modules usable in both HM and nixos (and perhaps other places) |
| [nixos](./nixos)               | Nixos specific functionality                                    |
| [home-manager](./home-manager) | Home manager specific functionality                            |

## Common modules

| Name                                            | Attribute                   | Description                              | Dependencies                                   |
| ----------------------------------------------- | --------------------------- | ---------------------------------------- | ---------------------------------------------- |
| [lua-colorscheme](./common/lua-colorscheme.nix) | `satellite.colorscheme.lua` | Base16 theme to lua module generation    | [stylix](https://github.com/danth/stylix)      |
| [lua-lib](./common/lua-lib.nix)                 | `satellite.lib.lua`         | Helpers for working with lua code        |                                                |
| [korora-lua](./common/korora-lua.nix)           | -                           | Nix -> lua encoder                       | [korora](https://github.com/adisbladis/korora) |
| [korora-neovim](./common/korora-neovim.nix)     | -                           | Nix -> neovim config helpers             | [korora](https://github.com/adisbladis/korora) |
| [theming](./common/theming.nix)                 | `satellite.theming`         | Base16 theming helpers and configuration | [stylix](https://github.com/danth/stylix)      |
| [toggles](./common/toggles.nix)                 | `satellite.toggles`         | Generic interface for feature flags      |                                                |

## Nixos modules

| Name                         | Attribute         | Description                              | Dependencies |
| ---------------------------- | ----------------- | ---------------------------------------- | ------------ |
| [pounce](./nixos/pounce.nix) | `services.pounce` | Module for pounce & calico configuration |              |
| [nginx](./nixos/nginx.nix)   | `satellite.proxy` | Helpers for nginx configuration          |              |

## Home-manager modules

| Name                                              | Attribute               | Description                                                                       | Dependencies                                                  |
| ------------------------------------------------- | ----------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| [discord](./home-manager/discord.nix)             | `programs.discord`      | Additional discord options                                                        |                                                               |
| [firefox](./home-manager/firefox)                 | `programs.firefox.apps` | Hacky system for wrapping websites into desktop apps by hiding the firefox tabbar |                                                               |
| [hyprpaper](./home-manager/hyprpaper.nix)         | `services.hyprpaper`    | Wallpaper service for `hyprland`                                                  |                                                               |
| [monitors](./home-manager/monitors.nix)           | `satellite.monitors`    | WM generic monitor configuration                                                  |                                                               |
| [persistence](./home-manager/persistence.nix)     | `satellite.persistence` | Syntactic wrapper around impermanence                                             | [impermanence](https://github.com/nix-community/impermanence) |
| [satellite-dev](./home-manager/satellite-dev.nix) | `satellite.dev`         | Helpers for managing dotfiles which are actively under development                |                                                               |
