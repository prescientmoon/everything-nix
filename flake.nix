{
  description = "Satellite";

  # {{{ Inputs
  inputs = {
    # {{{ Nixpkgs instances 
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # }}}
    # {{{ Additional package repositories
    nur.url = "github:nix-community/NUR";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Contains a bunch of wayland stuff not on nixpkgs
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    # Firefox addons
    firefox-addons.url = "git+https://gitlab.com/rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    # }}}
    # {{{ Nix-related tooling
    # {{{ Storage 
    impermanence.url = "github:nix-community/impermanence";

    # Declarative partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # }}}

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    korora.url = "github:adisbladis/korora";

    # Nix language server
    # [the docs](https://github.com/nix-community/nixd/blob/main/docs/user-guide.md#installation)
    # tell me not to override the nixpkgs input.
    nixd.url = "github:nix-community/nixd";
    # }}}
    # {{{ Standalone software
    # {{{ Nightly versions of things
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/happenslol/wezterm/blob/add-nix-flake/nix/flake.nix
    wezterm.url = "github:happenslol/wezterm/add-nix-flake?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # }}}
    # {{{ Self management
    # Smos
    smos.url = "github:NorfairKing/smos";
    # REASON: smos fails to build this way
    # smos.inputs.nixpkgs.follows = "nixpkgs";
    # smos.inputs.home-manager.follows = "home-manager";

    # Intray
    intray.url = "github:Mateiadrielrafael/intray";
    intray.inputs.nixpkgs.follows = "nixpkgs";
    intray.inputs.home-manager.follows = "home-manager";

    # Tickler
    tickler.url = "github:NorfairKing/tickler";
    tickler.inputs.nixpkgs.follows = "nixpkgs";
    tickler.inputs.intray.follows = "intray";
    # }}}
    # {{{ Anyrun 
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";
    anyrun-nixos-options.inputs.nixpkgs.follows = "nixpkgs";
    # }}}

    matui.url = "github:pkulak/matui";
    matui.inputs.nixpkgs.follows = "nixpkgs";

    # Spotify client with theming support
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Keyboard configuration (to be replaced by kanata at some point)
    slambda.url = "github:Mateiadrielrafael/slambda";
    slambda.inputs.nixpkgs.follows = "nixpkgs";
    # }}}
    # {{{ Theming
    # Grub2 themes
    grub2-themes.url = "github:vinceliuice/grub2-themes";
    grub2-themes.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    # Catpuccin base16 color schemes
    catppuccin-base16.url = "github:catppuccin/base16";
    catppuccin-base16.flake = false;

    # Rosepine base16 color schemes
    rosepine-base16.url = "github:edunfelt/base16-rose-pine-scheme";
    rosepine-base16.flake = false;
    # }}}
  };
  # }}}

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # {{{ Common helpers 
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        # "aarch64-linux" TODO: purescript doesn't work on this one
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      specialArgs = system: {
        inherit inputs outputs;

        spkgs = inputs.nixpkgs-stable.legacyPackages.${system};
        upkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
      };
      # }}}
    in
    {
      # {{{ Packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # }}}
      # {{{ Bootstrapping and other pinned devshells
      # Acessible through 'nix develop'
      devShells = forAllSystems
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            args = { inherit pkgs; } // specialArgs system;
          in
          import ./devshells args);
      # }}}
      # {{{ Overlays and modules
      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays;

      # Reusable nixos modules
      nixosModules = import ./modules/nixos // import ./modules/common;

      # Reusable home-manager modules
      homeManagerModules = import ./modules/home-manager // import ./modules/common;
      # }}}
      # {{{ Nixos
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#...
      nixosConfigurations =
        let nixos = { system, hostname, user }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs system;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.users.${user} = import ./home/${hostname}.nix;
              home-manager.extraSpecialArgs = specialArgs system // { inherit hostname; };
              home-manager.useUserPackages = true;

              stylix.homeManagerIntegration.followSystem = false;
              stylix.homeManagerIntegration.autoImport = false;
            }

            ./hosts/nixos/${hostname}
          ];
        };
        in
        {
          tethys = nixos {
            system = "x86_64-linux";
            hostname = "tethys";
            user = "adrielus";
          };

          lapetus = nixos {
            system = "x86_64-linux";
            hostname = "lapetus";
            user = "adrielus";
          };

          # Disabled because `flake check` complains about filesystems and bootloader
          # options not being set. This is not an issue in practice, as this config is
          # supposed to be used inside a VM, but there's not much I can do about it.
          # euporie = nixos {
          #   system = "x86_64-linux";
          #   hostname = "euporie";
          #   user = "guest";
          # };

        };
      # }}}
      # {{{ Home manager
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#...
      homeConfigurations =
        let
          mkHomeConfig = { system, hostname }:
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${system};
              extraSpecialArgs = specialArgs system // { inherit hostname; };
              modules = [ ./home/${hostname}.nix ];
            };
        in
        {
          nixd = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages."x86_64-linux";
            modules = [
              ({ lib, config, ... }: {
                home = {
                  username = "adrielus";
                  homeDirectory = "/home/${config.home.username}";
                  stateVersion = "23.05";
                };
              })
            ];
          };
          "adrielus@tethys" = mkHomeConfig {
            system = "x86_64-linux";
            hostname = "tethys";
          };
          "guest@euporie" = mkHomeConfig {
            system = "x86_64-linux";
            hostname = "euporie";
          };
          "adrielus@lapetus" = mkHomeConfig {
            system = "x86_64-linux";
            hostname = "lapetus";
          };
        };
      # }}}
    };

  # {{{ Caching and whatnot
  # TODO: persist trusted substituters file
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org" # I think I need this for neovim-nightly?
      "https://nixpkgs-wayland.cachix.org"
      "https://anyrun.cachix.org"
      "https://smos.cachix.org"
      "https://intray.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "smos.cachix.org-1:YOs/tLEliRoyhx7PnNw36cw2Zvbw5R0ASZaUlpUv+yM="
      "intray.cachix.org-1:qD7I/NQLia2iy6cbzZvFuvn09iuL4AkTmHvjxrQlccQ="
    ];
  };
  # }}}
}
