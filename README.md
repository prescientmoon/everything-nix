# Welcome to *the Satellite*

In case you are not familiar with nix/nixos, this is a collection of configuration files which build my entire system in a declarative manner. The tool used to configure the global system is called [nixos](https://nixos.org/), and the one used to configure the individual users is called [home-manager](https://github.com/nix-community/home-manager). 

### Features this repository includes:

- Consistent base16 theming using [stylix](https://github.com/danth/stylix)
- [Agenix](https://github.com/ryantm/agenix) & [homeage](https://github.com/jordanisaacs/homeage) based secret management 
- Sets up all the apps I use — including git, neovim, fish, tmux, starship, xmonad, rofi, polybar, discord, zathura, alacritty & more. 

### In the future I might start using any of the other cool nix-based tools, like:

- [nix-darwin](https://github.com/LnL7/nix-darwin) - like nixos but for macs
- [disko](https://github.com/nix-community/disko) - format disks using nix
- [impernanence](https://github.com/nix-community/impermanence) - see the article about [erasing your darlings](https://grahamc.com/blog/erase-your-darlings)

The current state of this repo is a refactor of my old, messy nixos config, based on the structure of [this template](https://github.com/Misterio77/nix-starter-configs).

### Hosts

This repo's structure is based on the concept of hosts - individual machines configured by me. I'm naming each host based on things in space/mythology (*they are the same picture*). The hosts I have right now are:

- [tethys](./hosts/nixos) - my personal laptop

### Points of interest

Here's some things you might want to check out:

- My [neovim config](./dotfiles/neovim)
- The [flake](./flake.nix) entrypoint for this repository

### Links to everything used here:

> Well, this does not include links to every plugin I used for every program here, you can see more details in the respective configurations

- [nixos](http://nixos.org/) - nix based operating system
- [home-manager](https://github.com/nix-community/home-manager) - manage user configuration using nix
- [stylix](https://github.com/danth/stylix) - base16 module for nix
    - [Base16 templates](https://github.com/chriskempson/base16-templates-source) - list of base16 theme templates
    - [Catpuccin](https://github.com/catppuccin/catppuccin) - base16 theme I use
    - [Rosepine](https://rosepinetheme.com/) - another theme I use
- [Agenix](https://github.com/ryantm/agenix) & [homeage](https://github.com/jordanisaacs/homeage) - secret management
- [Xmonad](https://xmonad.org/) - window manager
    - [Polybar](https://github.com/polybar/polybar) - desktop bar
    - [Rofi](https://github.com/davatorium/rofi) - program launcher
- [Neovim](https://neovim.io/) - my editor
  - [Neovide](https://neovide.dev/index.html) - neovim gui client
  - [Vimclip](https://github.com/hrantzsch/vimclip) - vim anywhere!
  - [Firenvim](https://github.com/glacambre/firenvim) - embed neovim in web browsers
- [Tmux](https://github.com/tmux/tmux/wiki) - terminal multiplexer
- [Alacritty](https://github.com/alacritty/alacritty) - terminal emulator
- [Fish](https://fishshell.com/) - user friendly shell
  - [Starship](https://starship.rs/) - shell prompt
- [Zathura](https://pwmt.org/projects/zathura/) - pdf viewer
- [Ranger](https://github.com/ranger/ranger) - file manager
- [Firefox](https://www.mozilla.org/en-US/firefox/) - web browser
