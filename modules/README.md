# Modules

This directory contains custom module definitions used throughout my config.

## File structure

| Directory                      | Description                                                    |
| ------------------------------ | -------------------------------------------------------------- |
| [common](./common)             | Modules usable in both HM and nixos (and perhaps other places) |
| [nixos](./nixos)               | Nixos specific functinality                                    |
| [home-manager](./home-manager) | Home manager specific functionality                            |

## Common modules

| Name                                            | Attribute                   | Description                              | Dependencies                              |
| ----------------------------------------------- | --------------------------- | ---------------------------------------- | ----------------------------------------- |
| [lua-colorscheme](./common/lua-colorscheme.nix) | `satellite.colorscheme.lua` | Base16 theme to lua module generation    | [stylix](https://github.com/danth/stylix) |
| [theming](./common/theming.nix)                 | `satellite.theming`         | Base16 theming helpers and configuration | [stylix](https://github.com/danth/stylix) |
| [toggles](./common/toggles.nix)                 | `satellite.toggles`         | Generic interface for feature flags      |                                           |

## Nixos modules

There are no nixos modules at the moment!

## Home-manager modules

| Name                                              | Attribute               | Description                                                        | Dependencies                                                  |
| ------------------------------------------------- | ----------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------- |
| [discord](./home-manager/discord.nix)             | `programs.discord`      | Additional discord options                                         |                                                               |
| [eww-hyprland](./home-manager/eww-hyprland.nix)   | `programs.eww-hyprland` | `eww` service for `hyprland`                                       |                                                               |
| [hyprpaper](./home-manager/hyprpaper.nix)         | `services.hyprpaper`    | Wallpaper service for `hyprland`                                   |                                                               |
| [monitors](./home-manager/monitors.nix)           | `satellite.monitors`    | WM generic monitor configuration                                   |                                                               |
| [persistence](./home-manager/persistence.nix)     | `satellite.persistence` | Syntactic wrapper around impermanence                              | [impermanence](https://github.com/nix-community/impermanence) |
| [satellite-dev](./home-manager/satellite-dev.nix) | `satellite.dev`         | Helpers for managing dotfiles which are actively under development |                                                               |
