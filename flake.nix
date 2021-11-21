{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # easy-dhall-nix.url = "github:justinwoo/easy-dhall-nix";
    # easy-dhall-nix.flake = false;
    # # easy-dhall-nix.inputs.nixpkgs.follows = "nixpkgs";

    # easy-purescript-nix.url = "github:justinwoo/easy-purescript-nix";
    # easy-purescript-nix.flake = false;
    # easy-purescript-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixos-unstable,
    # easy-purescript-nix,
    # easy-dhall-nix,
    ... }: {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./hardware/laptop.nix
          ./configuration.nix
        ];
      };
    };
}
