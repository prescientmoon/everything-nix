{
  description = "Satellite";

  # {{{ Inputs
  inputs = {
    # {{{ Nixpkgs instances
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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

    home-manager.url = "github:nix-community/home-manager/release-24.05";
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
    # smos.inputs.nixpkgs.url = "github:NixOS/nixpkgs/b8dd8be3c790215716e7c12b247f45ca525867e2";

    # Intray
    intray.url = "github:NorfairKing/intray";
    # intray.inputs.nixpkgs.url = "github:NixOS/nixpkgs/fc07dc3bdf2956ddd64f24612ea7fc894933eb2e";
    # }}}

    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    miros.url = "github:prescientmoon/miros";
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

    base16-schemes.url = "github:tinted-theming/schemes";
    base16-schemes.flake = false;
    # }}}
  };
  # }}}

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # {{{ Common helpers
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

      specialArgs = system: {
        inherit inputs outputs;

        upkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
      };
      # }}}
    in
    {
      # {{{ Packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            upkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
            myPkgs = import ./pkgs { inherit pkgs upkgs; };
          in
          myPkgs // {
            octodns = upkgs.octodns.withProviders
              (ps: [ myPkgs.octodns-cloudflare ]);
          } // (import ./dns/pkgs.nix) { inherit pkgs self system; }
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
        let nixos = { system, hostname }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs system;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.users.pilot = import ./home/${hostname}.nix;
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
          };

          lapetus = nixos {
            system = "x86_64-linux";
            hostname = "lapetus";
          };

          # Disabled because `flake check` complains about filesystems and bootloader
          # options not being set. This is not an issue in practice, as this config is
          # supposed to be used inside a VM, but there's not much I can do about it.
          # euporie = nixos {
          #   system = "x86_64-linux";
          #   hostname = "euporie";
          # };

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
