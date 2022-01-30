{ system }:
{ home-manager, nixpkgs, nixpkgs-unstable, nixos-unstable, easy-purescript-nix
, easy-dhall-nix, z, agnoster, githubNvimTheme, vim-extra-plugins, ... }:
({ pkgs, ... }: {
  nix.registry.nixpkgs.flake = nixpkgs;
  nixpkgs.overlays = [
    vim-extra-plugins.overlay
    (self: super: {
      # inherit nixos-unstable;
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };

      easy-purescript-nix = import easy-purescript-nix { inherit pkgs; };
      easy-dhall-nix = import easy-dhall-nix { inherit pkgs; };

      z = {
        src = z;
        name = "z";
      };

      agnoster = {
        src = agnoster;
        name = "agnoster";
      };

      githubNvimTheme = githubNvimTheme;
    })
  ];
})
