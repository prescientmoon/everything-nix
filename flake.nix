{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    easy-dhall-nix.url = "github:justinwoo/easy-dhall-nix";
    easy-dhall-nix.flake = false;

    easy-purescript-nix.url = "github:justinwoo/easy-purescript-nix";
    easy-purescript-nix.flake = false;

    z.url = "github:jethrokuan/z";
    z.flake = false;

    agnoster.url = "github:oh-my-fish/theme-agnoster";
    agnoster.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, nixos-unstable, easy-purescript-nix
    , easy-dhall-nix, z, agnoster, ... }: {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./hardware/laptop.nix
          ./configuration.nix

          # Make inputs available inside the config
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              (self: super: {
                easy-purescript-nix =
                  import easy-purescript-nix { inherit pkgs; };
                easy-dhall-nix = import easy-dhall-nix { inherit pkgs; };

                z = {
                  src = z;
                  name = "z";
                };

                agnoster = {
                  src = agnoster;
                  name = "agnoster";
                };
              })
            ];
          })
        ];
      };
    };
}
