{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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

    githubNvimTheme.url = "github:projekt0n/github-nvim-theme";
    githubNvimTheme.flake = true;
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      provideInputs =
        import ./modules/overlays/flakes.nix { inherit system; } inputs;
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          home-manager.nixosModules.home-manager
          provideInputs
          ./hardware/laptop.nix
          ./configuration.nix
        ];
      };
    };
}
