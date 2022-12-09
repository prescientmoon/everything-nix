{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # keyboard layout configuration
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    idris2-pkgs = {
      url = "github:claymager/idris2-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #### Nvim stuff
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, stylix, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      provideInputs =
        import ./modules/overlays/flakes.nix { inherit system; } inputs;

      overlays = { ... }: {
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.overlays = [
          inputs.neovim-nightly-overlay.overlay
          inputs.idris2-pkgs.overlay
          provideInputs
        ];
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          paths = import ./paths.nix;
          inherit inputs;
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.kmonad.nixosModule
          stylix.nixosModules.stylix
          overlays
          ./hardware/laptop.nix
          ./configuration.nix
        ];
      };
    };
}
