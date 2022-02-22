{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    vim-extra-plugins.url = "github:m15a/nixpkgs-vim-extra-plugins";

    # Git repo fetching
    telescope-file-browser-nvim = {
      url = "github:nvim-telescope/telescope-file-browser.nvim";
      flake = false;
    };

    easy-dhall-nix = {
      url = "github:justinwoo/easy-dhall-nix";
      flake = false;
    };

    easy-purescript-nix = {
      url = "github:justinwoo/easy-purescript-nix";
      flake = false;
    };

    z = {
      url = "github:jethrokuan/z";
      flake = false;
    };

    agnoster = {
      url = "github:oh-my-fish/theme-agnoster";
      flake = false;
    };

    githubNvimTheme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      provideInputs =
        import ./modules/overlays/flakes.nix { inherit system; } inputs;

      overlays = { ... }: {
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.overlays = [
          inputs.vim-extra-plugins.overlay
          inputs.neovim-nightly-overlay.overlay
          provideInputs
        ];
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          home-manager.nixosModules.home-manager
          overlays
          ./hardware/laptop.nix
          ./configuration.nix
        ];
      };
    };
}
