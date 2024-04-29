{
  description = "Satellite";

  # {{{ Inputs
  inputs = {
    # {{{ Nixpkgs instances
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # }}}
    # {{{ Additional package repositories
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
    # }}}
    # {{{ Standalone software
    # {{{ Nightly versions of things
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # }}}
    # {{{ Self management
    # Smos
    smos.url = "github:NorfairKing/smos";
    smos.inputs.nixpkgs.url = "github:NixOS/nixpkgs/b8dd8be3c790215716e7c12b247f45ca525867e2";
    # REASON: smos fails to build this way
    # smos.inputs.nixpkgs.follows = "nixpkgs";
    # smos.inputs.home-manager.follows = "home-manager";

    # Intray
    intray.url = "github:NorfairKing/intray";
    intray.inputs.nixpkgs.url = "github:NixOS/nixpkgs/cf28ee258fd5f9a52de6b9865cdb93a1f96d09b7";
    # intray.inputs.home-manager.follows = "home-manager";
    # }}}

    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    miros.url = "github:mateiadrielrafael/miros";
    miros.inputs.nixpkgs.follows = "nixpkgs";

    # Spotify client with theming support
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    # }}}
    # {{{ Theming
    darkmatter-grub-theme.url = gitlab:VandalByte/darkmatter-grub-theme;
    darkmatter-grub-theme.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/a33d88cf8f75446f166f2ff4f810a389feed2d56";
    # stylix.inputs.nixpkgs.follows = "nixpkgs";
    # stylix.inputs.home-manager.follows = "home-manager";

    catppuccin-base16.url = "github:catppuccin/base16";
    catppuccin-base16.flake = false;

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

        upkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
      };
      # }}}
    in
    {
      # {{{ Packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # }}}
      # {{{ Bootstrapping and other pinned devshells
      # Accessible through 'nix develop'
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
      "https://nix-community.cachix.org"
      # "https://anyrun.cachix.org"
      "https://smos.cachix.org"
      "https://intray.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "smos.cachix.org-1:YOs/tLEliRoyhx7PnNw36cw2Zvbw5R0ASZaUlpUv+yM="
      "intray.cachix.org-1:qD7I/NQLia2iy6cbzZvFuvn09iuL4AkTmHvjxrQlccQ="
    ];
  };
  # }}}
}
