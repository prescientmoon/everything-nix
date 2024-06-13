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

## Nixos modules

| Name                                   | Attribute               | Description                                 |
| -------------------------------------- | ----------------------- | ------------------------------------------- |
| [pounce](./nixos/pounce.nix)           | `services.pounce`       | Module for pounce & calico configuration    |
| [nginx](./nixos/nginx.nix)             | `satellite.nginx`       | Helpers for nginx configuration             |
| [ports](./nixos/ports.nix)             | `satellite.ports`       | Global port specification                   |
| [cloudflared](./nixos/cloudflared.nix) | `satellite.cloudflared` | Helpers for cloudflare tunnel configuration |
| [pilot](./nixos/pilot.nix)             | `satellite.pilot`       | Defined the concept of a "main user"        |

## Home-manager modules

| Name                                              | Attribute               | Description                                                                            |
| ------------------------------------------------- | ----------------------- | -------------------------------------------------------------------------------------- |
| [discord](./home-manager/discord.nix)             | `programs.discord`      | Additional discord options                                                             |
| [firefox](./home-manager/firefox)                 | `programs.firefox.apps` | Hacky system for wrapping websites into desktop apps by hiding the firefox tabbar      |
| [monitors](./home-manager/monitors.nix)           | `satellite.monitors`    | WM generic monitor configuration                                                       |
| [persistence](./home-manager/persistence.nix)     | `satellite.persistence` | Syntactic wrapper around [impermanence](https://github.com/nix-community/impermanence) |
| [satellite-dev](./home-manager/satellite-dev.nix) | `satellite.dev`         | Helpers for managing dotfiles which are actively under development                     |
