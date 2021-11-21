{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home.url = "github:nix-community/home-manager/release-21.05";
    home.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, home-manager, ... }: {
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
