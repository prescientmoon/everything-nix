{ ... }:
let
  imports = import ../nix/sources.nix;
  unstable = import imports.nixpkgs-unstable { config.allowUnfree = true; };
in {
  nixpkgs.overlays = [
    (self: super:
      with self; rec {
        inherit imports;
        inherit unstable;

        inherit (import imports.niv { }) niv;

        cached-nix-shell = callPackage imports.cached-nix-shell { };
        easy-purescript-nix = callPackage imports.easy-purescript-nix { };

        all-hies = import imports.all-hies { };
        snack = (import imports.snack).snack-exe;

        # unstable stuff
        brave = unstable.brave;
        vscodium = unstable.vscodium;
      })
  ];

  # allow packages with unfree licenses
  nixpkgs.config.allowUnfree = true;

  nix = {
    trustedUsers = [ "root" "adrielus" "@wheel" ];
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    binaryCaches = [ "https://cache.nixos.org" "https://all-hies.cachix.org" ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
    ];
  };
}
