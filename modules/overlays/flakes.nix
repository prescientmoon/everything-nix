{ system }:
{ home-manager, nixpkgs-unstable, nixos-unstable, easy-purescript-nix
, easy-dhall-nix, z, agnoster, ... }:
({ pkgs, ... }: {
  nixpkgs.overlays = [
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
    })
  ];
})
