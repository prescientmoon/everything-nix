{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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

    # Plugin which enables me to create chords (aka keybinds where everything must be set at the same time)
    vim-plugin-arpeggio = {
      url = "github:kana/vim-arpeggio";
      flake = false;
    };

    vim-plugin-kmonad = {
      url = "github:kmonad/kmonad-vim";
      flake = false;
    };

    nvim-plugin-agda = {
      url = "github:isti115/agda.nvim";
      flake = false;
    };

    nvim-plugin-idris2 = {
      url = "github:ShinKage/idris2-nvim";
      flake = false;
    };

    # Create / delete files within telescope
    telescope-file-browser-nvim = {
      url = "github:nvim-telescope/telescope-file-browser.nvim";
      flake = false;
    };

    # Github inspired theme for a bunch of stuff
    githubNvimTheme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };

    #### Purescript stuff
    easy-dhall-nix = {
      url = "github:justinwoo/easy-dhall-nix";
      flake = false;
    };

    easy-purescript-nix = {
      url = "github:justinwoo/easy-purescript-nix";
      flake = false;
    };

    #### Fish stuff
    fish-plugin-z = {
      url = "github:jethrokuan/z";
      flake = false;
    };

    fish-theme-agnoster = {
      url = "github:oh-my-fish/theme-agnoster";
      flake = false;
    };

    fish-theme-harleen = {
      url = "github:aneveux/theme-harleen";
      flake = false;
    };

    fish-theme-dangerous = {
      url = "github:oh-my-fish/theme-dangerous";
      flake = false;
    };

    oh-my-fish = {
      url = "github:oh-my-fish/oh-my-fish";
      flake = false;
    };

    #### Other github stuff
    sddm-theme-chili = {
      url = "github:MarianArlt/sddm-chili";
      flake = false;
    };
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
