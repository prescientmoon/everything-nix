{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
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

    vim-extra-plugins.url = "github:m15a/nixpkgs-vim-extra-plugins";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      provideInputs =
        import ./modules/overlays/flakes.nix { inherit system; } inputs;

      overlays = { ... }: {
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.overlays = [
          inputs.vim-extra-plugins.overlay
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
        };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.kmonad.nixosModule
          overlays
          ./hardware/laptop.nix
          ./configuration.nix
        ];
      };
    };
}
