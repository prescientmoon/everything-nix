{
  inputs = {
    # {{{ Nixpkgs instances
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # My own nixpkgs fork
    starlitpkgs.url = "github:starlitcanopy/nixpkgs/pounce-libretls";
    # }}}
    # {{{ Additional package repositories
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Firefox add-ons
    firefox-addons.url = "git+https://gitlab.com/rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    # }}}
    # {{{ Nix-related tooling
    # Declarative partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    korora.url = "github:adisbladis/korora";
    # }}}
    # {{{ Standalone software
    miros.url = "github:prescientmoon/miros";
    miros.flake = false;

    shimmeringmoon.url = "github:prescientmoon/shimmeringmoon";
    # shimmeringmoon.url = "git+ssh://forgejo@ssh.git.moonythm.dev/prescientmoon/shimmeringmoon.git";
    shimmeringmoon.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nihil.url = "github:prescientmoon/nihil";
    # nihil.url = "git+ssh://forgejo@ssh.git.moonythm.dev/prescientmoon/nihil.git";
    nihil.flake = false;

    # NOTE: we import the TOML from there into nix, thus we have to flake this ;-;
    sillyring.url = "github:prescientmoon/sillyring";
    # sillyring.url = "git+ssh://forgejo@ssh.git.moonythm.dev/prescientmoon/sillyring.git";
    sillyring.flake = false;
    # }}}
    # {{{ Theming
    stylix.url = "github:danth/stylix/release-26.05";
    # stylix.inputs.nixpkgs.follows = "nixpkgs";
    # stylix.inputs.home-manager.follows = "home-manager";

    base16-schemes.url = "github:tinted-theming/schemes";
    base16-schemes.flake = false;
    # }}}
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      # {{{ Common helpers
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

      specialArgs = system: {
        inherit inputs outputs;

        upkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
        spkgs = inputs.starlitpkgs.legacyPackages.${system};
      };
    in
    # }}}
    {
      # {{{ Packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          upkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
          myPkgs = import ./pkgs { inherit pkgs upkgs; };
        in
        myPkgs
        // (import ./dns/implementation) {
          inherit pkgs;
          extraModules = [ ./dns/config/common.nix ];
          octodnsConfig = ./dns/config/octodns.yaml;
          nixosConfigurations = removeAttrs self.nixosConfigurations [ "iso" ];
        }
        // {
          inherit (import ./migadux { inherit pkgs; }) migadux;
          temp = upkgs.python3Packages.callPackage ./home/features/cli/beets/beets-vgmdb.nix { };
        }
      );
      # }}}
      # {{{ Bootstrapping and other pinned devshells
      # Accessible through 'nix develop'
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          args = {
            inherit pkgs;
          }
          // specialArgs system;
        in
        import ./devshells args
      );
      # }}}
      # {{{ Overlays and modules
      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays // {
        shimmeringmoon = inputs.shimmeringmoon.overlays.default;
      };

      # Reusable nixos modules
      nixosModules = import ./modules/nixos // import ./modules/common;
      # }}}
      # {{{ Nixos
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#...
      nixosConfigurations =
        let
          nixos =
            { system, hostname }:
            nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = specialArgs system;

              modules = [
                # {{{ Import home manager
                (
                  { lib, ... }:
                  {
                    imports = lib.lists.optionals (builtins.pathExists ./home/${hostname}.nix) [
                      inputs.home-manager.nixosModules.home-manager
                      {
                        home-manager.users.pilot = ./home/${hostname}.nix;
                        home-manager.extraSpecialArgs = specialArgs system // {
                          inherit hostname;
                        };
                        home-manager.useUserPackages = true;
                        home-manager.backupFileExtension = "hm-backup";

                        stylix.homeManagerIntegration.followSystem = false;
                        stylix.homeManagerIntegration.autoImport = false;
                      }
                    ];
                  }
                )
                # }}}

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

          calypso = nixos {
            system = "x86_64-linux";
            hostname = "calypso";
          };

          iso = nixos {
            system = "x86_64-linux";
            hostname = "iso";
          };
        };
      # }}}
    };
}
