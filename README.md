# Welcome to _the Satellite_

> Note: a lot of the info in this README might be a bit outdated. I plan to document things on my website once I finish rebuilding it.

In case you are not familiar with nix/nixos, this is a collection of configuration files which build all my systems in a declarative manner. The tool used to configure the global system is called [nixos](https://nixos.org/), and the one used to configure the individual users is called [home-manager](https://github.com/nix-community/home-manager).

> A [visual history](./docs/history.md) of my setup is in the works!

> Woah, I can't believe this repo made it to 1000 commits :O

## Features this repository includes:

- Sets up all the apps I use — including git, neovim, fish, starship, hyprland, anyrun, discord, zathura, foot & much more.
- Sets up my entire homelab — including zfs-based [impermanence](https://grahamc.com/blog/erase-your-darlings), automatic let's-encrypt certificates, tailscale, syncthing, vaultwarden, whoogle, pounce, calico, actual & more.
- Consistent base16 theming using [stylix](https://github.com/danth/stylix)
- Declarative secret management using [sops-nix](https://github.com/Mic92/sops-nix)

The current state of this repo is a refactor of my old, messy nixos config, based on the structure of [this template](https://github.com/Misterio77/nix-starter-configs).

## Hosts

This repo's structure is based on separating configuration into individual hosts - different machines configured by me. Each host is named after things in space/mythology (_they are the same picture_). The hosts I have right now are:

- [calypso](./hosts/nixos/calypso/) — my personal laptop
- [tethys](./hosts/nixos/tethys/) — my previous personal laptop
- [lapetus](./hosts/nixos/lapetus/) — older laptop running as a server

The following hosts are not configured using nix, but might be referenced in places:

- chaldene — my current phone
- enceladus — my previous phone
- erriapus — my tablet
- euporie — VM used for testing

## File structure

| Location                     | Description                                         |
| ---------------------------- | --------------------------------------------------- |
| [common](./common)           | Configuration loaded on both nixos and home-manager |
| [devshells](./devshells)     | Nix shells                                          |
| [dns](./dns)                 | Directory for parts of my octodns nix-based wrapper |
| [docs](./docs)               | Additional documentation regarding my setup         |
| [home](./home)               | Home manager configurations                         |
| [hosts/nixos](./hosts/nixos) | Nixos configurations                                |
| [modules](./modules)         | Custom generic/nixos/home-manager modules           |
| [overlays](./overlays)       | Nix overlays                                        |
| [pkgs](./pkgs)               | Nix packages                                        |
| [flake.nix](./flake.nix)     | Nix flake entrypoint!                               |
| [scripts](./scripts)         | Bash scripts that come in handy when on a live cd   |
| [.sops.yaml](./.sops.yaml)   | Sops entrypoint                                     |
| [stylua.toml](./stylua.toml) | Lua formatter config for the repo                   |

## Points of interest

Here's some things you might want to check out:

- My [neovim config](./home/features/neovim/default.nix)
- written using a [custom neovim config generation framework](./modules/common/korora-neovim.nix)
- [snippets](./home/features/neovim/snippets) written in [miros](https://github.com/prescientmoon/miros) — my custom snippet generation language
- The [flake](./flake.nix) entrypoint for this repository

## Things I use

> This does not include links to every plugin I use for every program here. You can see more details in the respective configurations.

### Fundamentals

- [Nixos](http://nixos.org/) — nix based operating system
- [Home-manager](https://github.com/nix-community/home-manager) — manage user configuration using nix
- [Impernanence](https://github.com/nix-community/impermanence) — see the article about [erasing your darlings](https://grahamc.com/blog/erase-your-darlings)
- [Sops-nix](https://github.com/Mic92/sops-nix) — secret management
- [disko](https://github.com/nix-community/disko) — format disks using nix
- [zfs](https://openzfs.org/wiki/Main_Page) — filesystem (on my server)
- [btrfs](https://btrfs.readthedocs.io/en/latest/) — filesystem (on my laptop)

### Input handling

- [kanata](https://github.com/jtroo/kanata) — software-level keyboard layout customizer. One of the few such programs with support for chording
- [opentabletdriver](https://opentabletdriver.net/)

### Graphical

- [Stylix](https://github.com/danth/stylix) — base16 module for nix
- [Base16 templates](https://github.com/chriskempson/base16-templates-source) — list of base16 theme templates
- [Catpuccin](https://github.com/catppuccin/catppuccin) — base16 theme I use
- [Rosepine](https://rosepinetheme.com/) — another theme I use
- [Gruvbox](https://github.com/morhetz/gruvbox) — yet another theme I use
- [Hyprland](https://hyprland.org/) — wayland compositor
- [Wlogout](https://github.com/ArtsyMacaw/wlogout) — wayland logout menu
- [Hyprpicker](https://github.com/hyprwm/hyprpicker) — hyprland color picker
- [Grimblast](https://github.com/hyprwm/contrib/tree/main/grimblast) — screenshot tool
- [Dunst](https://dunst-project.org/) — notification daemon
- [Wlsunset](https://sr.ht/~kennylevinsen/wlsunset/) — day/night screen gamma adjustments
- [Anyrun](https://github.com/Kirottu/anyrun) — program launcher
- [Foot](https://codeberg.org/dnkl/foot) — terminal emulator
- [Zathura](https://pwmt.org/projects/zathura/) — pdf viewer
- [Firefox](https://www.mozilla.org/en-US/firefox/) — web browser
- [Tesseract](https://github.com/tesseract-ocr/tesseract) — OCR engine
- [Bitwarden](https://bitwarden.com/) — client for self-hosted password manager

### Terminal

> There are many clis I use which I did not include here, for the sake of brevity.

- [Neovim](https://neovim.io/) — my editor
  - [Neovide](https://neovide.dev/index.html) — neovim gui client
  - [Vimclip](https://github.com/hrantzsch/vimclip) — vim anywhere!
- [Fish](https://fishshell.com/) — user friendly shell
  - [Starship](https://starship.rs/) — shell prompt
- [yazi](https://github.com/sxyazi/yazi) — file manager
- [Catgirl](https://git.causal.agency/catgirl/about/) — irc client
- [lazygit](https://github.com/jesseduffield/lazygit) — git tui

### Services

![homelab-homepage](docs/img/homelab-homepage.png)

Most services are served over [tailscale](https://tailscale.com/), using certificates generated by [let's encrypt](https://letsencrypt.org/).

- [Actual](https://actualbudget.org/) — budgeting tool.
- [Commafeed](https://github.com/Athou/commafeed) — rss reader
- [Forgejo](https://forgejo.org/) — git forge
- [Grafana](https://github.com/grafana/grafana) — pretty dashboards
- [Homer](https://github.com/bastienwirtz/homer) — server homepage
- [Invidious](https://invidious.io/) — alternate YouTube client
- [Jellyfin](https://jellyfin.org/) — media server
- [Jupyterhub](https://jupyter.org/hub) — notebook collaboration suite
- [Microbin](https://microbin.eu/) - code & file sharing service
- [Pounce](https://git.causal.agency/pounce/about/) & [calico](https://git.causal.agency/pounce/about/calico.1) — irc bouncer
- [Prometheus](https://github.com/prometheus/prometheus) — metric collector
- [Qbittorrent](https://www.qbittorrent.org) — torrent client
- [Radicale](https://radicale.org/v3.html) — calendar server
- [Redlib](https://github.com/redlib-org/redlib) — alternate Reddit client
- [Syncthing](https://syncthing.net/) — file synchronization
- [Vaultwarden](https://github.com/dani-garcia/vaultwarden/) — password manager
- [Whoogle](https://github.com/benbusby/whoogle-search#manual-docker) — search engine

## Hall of fame

This section contains links to things which used to be in the previous section but are not used anymore. This section was created in June 2023, hence stuff I dropped earlier might not be here. Moreover, this list is sorted with the most recently dropped things at the top, as a sort of reverse-timeline.

- [Obsidian](https://obsidian.md/) — I switched to my own markup language.
- [Smos](https://github.com/NorfairKing/smos) — Too complicated for my taste (I switched to simple text files)
- [gitlinker](https://github.com/linrongbin16/gitlinker.nvim) — I very rarely needed this
- [crates.nvim](https://github.com/saecki/crates.nvim) — Cool plugin, but I was rarely using its functionality
- [idris2-nvim](https://github.com/idris-community/idris2-nvim) — I haven't used Idris in a good while
- [lean.nvim](https://github.com/Julian/lean.nvim) — I haven't used Lean in a good while
- [github-actions-yaml.vim](https://github.com/yasuhiroki/github-actions-yaml.vim) — A yaml schema language server should do
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) — I never got this working properly anyways. I use [Seer](https://github.com/epasveer/seer) instead.
- [vim-djot](https://github.com/kolliemo/vim-djot) — not sure why I had this in, there's an official plugin + an unofficial treesitter grammar
- [Purescript-vim](https://github.com/purescript-contrib/purescript-vim) — The treesitter grammar should hopefully be enough
- [Neotest](https://github.com/nvim-neotest/neotest) — I was hardly ever using this
- [Navigator.nvim](https://github.com/numToStr/Navigator.nvim) — I no longer use tmux, nor Wezterm, hence this was a bit useless
- [microbin](https://github.com/szabodanika/microbin) — Was fairly clunky, thus I switched to [picoshare](https://github.com/mtlynch/picoshare)
- [sponge](https://github.com/meaningful-ooo/sponge) — I kept losing commands I wanted to keep in my history
- [hyprland-vim-syntax](https://github.com/theRealCarneiro/hyprland-vim-syntax) — Neovim supports hyprlang files out of the box now
- [typst.vim](https://github.com/kaarmu/typst.vim) — Neovim supports typst files out of the box now
- [ncdu](https://dev.yorhel.nl/ncdu) — A neat project I used on a regular basis. Ended up switching to [dua](https://github.com/Byron/dua-cli) (in interactive mode)
- [peek](https://github.com/phw/peek) — Doesn't seem to work on Wayland + GIFs are not a very efficient format
- [bc](https://github.com/gavinhoward/bc) — I was rarely using this
- [lovely-forks](https://github.com/musically-ut/lovely-forks) — I was rarely using this
- [Octotree](https://www.octotree.io/) — GitHub supports this natively now
- [Tmux](https://github.com/tmux/tmux/wiki) — I now simply use multiple WM windows / no longer persist sessions
- [Intray](https://github.com/NorfairKing/intray) — The server is no longer open source
- [Guacamole](https://guacamole.apache.org/) — I had little reason to keep this around on top of tailscale
- [htop](https://htop.dev/) — I switched to [bottom](https://github.com/ClementTsang/bottom), as the interface felt way cleaner
- [Wezterm](https://github.com/wez/wezterm) — I switched to [Foot](https://codeberg.org/dnkl/foot), as wezterm was laggy, unstable, and kept breaking between releases
- [Ranger](https://github.com/ranger/ranger) — I switched to [Yazi](https://github.com/sxyazi/yazi)
- [firenvim](https://glacambre/firenvim) - the concept is cool, but I found the whole thing pretty annoying at times
- [venn.nvim](https://jbyuki/venn.nvim) — the concept is cool, but I would use it about once a year
- [hydra.nvim](https://anuvyklack/hydra.nvim) — I was rarely using it, and it was taking up precious config space
- [winbar.nvim](https://github.com/fgheng/winbar.nvim) — I mostly had this here for the looks, so I moved the path it provided to my statusbar
- [treesitter-visual-context.nvim](https://github.com/haringsrob/nvim_context_vt) — felt like this was cluttering my screen more than anything
- [Paperplanes.nvim](https://rktjmp/paperplanes.nvim) — replaced by a single curl call
- [Eww](https://github.com/elkowar/eww) - experimented with eww for a bit, but setup was painful and bars are a bit useless
- [Neogit](https://github.com/NeogitOrg/neogit) — was a bit slow / clunky, so I switched to [lazygit](https://github.com/jesseduffield/lazygit)
- [Slambda](https://github.com/prescientmoon/slambda) — custom keyboard chording utility. I retired the project in favour of [kanata](https://github.com/jtroo/kanata)
- [GPG](https://gnupg.org/) + [pass](https://www.passwordstore.org/) — I switched to [vaultwarden](https://github.com/dani-garcia/vaultwarden/)
- [Agenix](https://github.com/ryantm/agenix) & [homeage](https://github.com/jordanisaacs/homeage) — I switched to [sops-nix](https://github.com/Mic92/sops-nix)
- [Mind.nvim](https://github.com/phaazon/mind.nvim) — self management tree editor. The project got archived, so I switched to [Smos](https://github.com/NorfairKing/smos).
- [Null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) — general purpose neovim LSP. The project got archived, so I switched to [formatter.nvim](https://github.com/mhartington/formatter.nvim).
- [Wofi](https://sr.ht/~scoopta/wofi/) — program launcher. I switched to [Anyrun](https://github.com/Kirottu/anyrun).
- [Alacritty](https://github.com/alacritty/alacritty) — terminal emulator. I switched to [Wezterm](https://wezfurlong.org/wezterm/).
- [Xmonad](https://xmonad.org/) — xorg window manager. I switched to [Hyprland](https://hyprland.org/).
  - [Polybar](https://github.com/polybar/polybar) — desktop bar
  - [Rofi](https://github.com/davatorium/rofi) — program launcher. I switched to [Wofi](https://sr.ht/~scoopta/wofi/).
  - [Spectacle](https://apps.kde.org/spectacle/) — screenshot tool. I switched to [Grimblast](https://github.com/hyprwm/contrib/tree/main/grimblast).
- [Chrome](https://www.google.com/chrome/) — web browser. I switched to `firefox` because it offers a better HM module.
