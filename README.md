# Welcome to *the Satellite*

In case you are not familiar with nix/nixos, this is a collection of configuration files which build my entire system in a declarative manner. The tool used to configure the global system is called [nixos](https://nixos.org/), and the tool used to configure the individual users is called [home-manager](https://github.com/nix-community/home-manager). 

### Features this repository include:

- Consistent base16 theming using [base16-nix](https://github.com/SenchoPens/base16.nix)
- [Agenix](https://github.com/ryantm/agenix) & [homeage](https://github.com/jordanisaacs/homeage) based secret management 
- Sets up all the apps I use, including git, neovim, fish, tmux, starship, xmonad, rofi, polybar, discord, zathura, alacritty & more. 

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
