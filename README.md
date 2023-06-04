# Welcome to _the Satellite_

In case you are not familiar with nix/nixos, this is a collection of configuration files which build my entire system in a declarative manner. The tool used to configure the global system is called [nixos](https://nixos.org/), and the one used to configure the individual users is called [home-manager](https://github.com/nix-community/home-manager).

### Features this repository includes:

- Consistent base16 theming using [stylix](https://github.com/danth/stylix)
- [Agenix](https://github.com/ryantm/agenix) & [homeage](https://github.com/jordanisaacs/homeage) based secret management
- Sets up all the apps I use — including git, neovim, fish, tmux, starship, xmonad, rofi, polybar, discord, zathura, alacritty & more.

The current state of this repo is a refactor of my old, messy nixos config, based on the structure of [this template](https://github.com/Misterio77/nix-starter-configs).

### Hosts

This repo's structure is based on the concept of hosts - individual machines configured by me. I'm naming each host based on things in space/mythology (_they are the same picture_). The hosts I have right now are:

- [tethys](./hosts/nixos) - my personal laptop
- [euporie](./hosts/euporie) - barebones host for testing things insdie a VM

### File structure

| Location                     | Description                                                        |
| ---------------------------- | ------------------------------------------------------------------ |
| [common](./common)           | Configuration loaded on both nixos and home-manager                |
| [dotfiles](./dotfiles)       | Contains some of the bigger dotfile dirs. Will eventually be moved |
| [hosts/nixos](./hosts/nixos) | Nixos configurations                                               |
| [home](./home)               | Home manager configurations                                        |
| [pkgs](./pkgs)               | Nix packages                                                       |
| [overlays](./overlays)       | Nix overlays                                                       |
| [devshells](./devshells)     | Nix shells                                                         |
| [stylua.toml](./stylua.toml) | Lua formatter config for the repo                                  |
| [flake.nix](./flake.nix)     | Nix flake entrypoint!                                              |
| [shell.nix](./shell.nix)     | Bootstrapping nix shell                                            |
| [nixpkgs.nix](./nixpkgs.nix) | Pinned nixpkgs for bootstrapping                                   |
| [secrets.nix](./secrets.nix) | Agenix entrypoint                                                  |

### Points of interest

Here's some things you might want to check out:

- My [neovim config](./dotfiles/neovim)
- The [flake](./flake.nix) entrypoint for this repository

### Links to everything used here:

> Well, this does not include links to every plugin I used for every program here, you can see more details in the respective configurations

- [Nixos](http://nixos.org/) - nix based operating system
- [Home-manager](https://github.com/nix-community/home-manager) - manage user configuration using nix
- [Impernanence](https://github.com/nix-community/impermanence) - see the article about [erasing your darlings](https://grahamc.com/blog/erase-your-darlings)
- [Stylix](https://github.com/danth/stylix) - base16 module for nix
  - [Base16 templates](https://github.com/chriskempson/base16-templates-source) - list of base16 theme templates
  - [Catpuccin](https://github.com/catppuccin/catppuccin) - base16 theme I use
  - [Rosepine](https://rosepinetheme.com/) - another theme I use
- [Agenix](https://github.com/ryantm/agenix) & [homeage](https://github.com/jordanisaacs/homeage) - secret management
- [Xmonad](https://xmonad.org/) - xorg window manager
  - [Polybar](https://github.com/polybar/polybar) - desktop bar
  - [Rofi](https://github.com/davatorium/rofi) - program launcher
  - [Spectacle](https://apps.kde.org/spectacle/) - screenshot tool
- [Hyprland](https://hyprland.org/) - wayland compositor
  - [Wlogout](https://github.com/ArtsyMacaw/wlogout) - wayland logout menu
  - [Wofi](https://sr.ht/~scoopta/wofi/) - program launcher
  - [Hyprpicker](https://github.com/hyprwm/hyprpicker) - hyprland color picker
  - [Grimblast](https://github.com/hyprwm/contrib/tree/main/grimblast) - screenshot tool
  - [Dunst](https://dunst-project.org/) - notification daemon
  - [Wlsunset](https://sr.ht/~kennylevinsen/wlsunset/) - day/night screen gamma adjustements
- [Neovim](https://neovim.io/) - my editor
  - [Neovide](https://neovide.dev/index.html) - neovim gui client
  - [Vimclip](https://github.com/hrantzsch/vimclip) - vim anywhere!
  - [Firenvim](https://github.com/glacambre/firenvim) - embed neovim in web browsers
- [Tmux](https://github.com/tmux/tmux/wiki) - terminal multiplexer
- [Alacritty](https://github.com/alacritty/alacritty) - terminal emulator
- [Wezterm](https://wezfurlong.org/wezterm/) - terminal emulator
- [Fish](https://fishshell.com/) - user friendly shell
  - [Starship](https://starship.rs/) - shell prompt
- [Zathura](https://pwmt.org/projects/zathura/) - pdf viewer
- [Ranger](https://github.com/ranger/ranger) - file manager
- [Firefox](https://www.mozilla.org/en-US/firefox/) - web browser
- [Tesseract](https://github.com/tesseract-ocr/tesseract) - OCR engine
- [Slambda](https://github.com/Mateiadrielrafael/slambda) - custom keyboard chording utility

### Hall of fame

Includes links to stuff which used to be in the previous section but is not used anymore. Only created this section in June 2023, so stuff I used earlier might not be here.

### Future

Tooling I might use in the future:
- [nix-darwin](https://github.com/LnL7/nix-darwin) - like nixos but for macs
- [disko](https://github.com/nix-community/disko) - format disks using nix
- [zfs](https://openzfs.org/wiki/Main_Page) - filesystem
- [eww](https://github.com/elkowar/eww) - widget framework
