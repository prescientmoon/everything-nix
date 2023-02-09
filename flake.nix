{
  description = "Satellite";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Homeage
    homeage.url = "github:jordanisaacs/homeage";
    homeage.inputs.nixpkgs.follows = "nixpkgs";

    # Base16-nix
    base16.url = github:SenchoPens/base16.nix;
    base16.inputs.nixpkgs.follows = "nixpkgs";

    # Catpuccin base16 color schemes
    catppuccin-base16.url = github:catppuccin/base16;
    catppuccin-base16.flake = false;

    # Rosepine base16 color schemes
    rosepine-base16.url = github:edunfelt/base16-rose-pine-scheme;
    rosepine-base16.flake = false;

    # Impermanence 
    impermanence.url = "github:nix-community/impermanence";

    # Neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      specialArgs = {
        inherit inputs outputs;

        # colorscheme = "${inputs.catppuccin-base16}/base16/latte.yaml";
        colorscheme = "${inputs.rosepine-base16}/rose-pine-dawn.yaml";
      };
    in
    rec {
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );

      # Devshell for bootstrapping
      # Acessible through 'nix develop'
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays;

      # Reusable nixos modules
      nixosModules = import ./modules/nixos;

      # Reusable home-manager modules
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#...
      nixosConfigurations = {
        tethys = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.users.adrielus = import ./home/adrielus/tethys.nix;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useUserPackages = true;
            }

            ./hosts/nixos/tethys
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#...
      homeConfigurations = {
        "adrielus@tethys" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home/adrielus/tethys.nix
          ];
        };
      };
    };

  # {{{ Caching and whatnot
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org" # I think I need this for neovim-nightly?
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  # }}}
}
