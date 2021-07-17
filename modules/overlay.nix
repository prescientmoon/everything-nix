{ ... }:
let
  imports = import ../nix/sources.nix;
  edoproPackage = import ./applications/edopro.nix;
  unstable = import imports.nixpkgs-unstable {
    config.allowUnfree = true;
    config.allowBroken = true;
  };
in {
  nixpkgs.overlays = [
    (self: super:
      with self; rec {
        inherit imports;
        inherit unstable;

        inherit (import imports.niv { }) niv;

        cached-nix-shell = callPackage imports.cached-nix-shell { };
        easy-purescript-nix = callPackage imports.easy-purescript-nix { };
        easy-dhall-nix = callPackage imports.easy-dhall-nix { };

        # This is a derivation I made myself for edopro
        edopro = callPackage edoproPackage { };

        all-hies = import imports.all-hies { };
        snack = (import imports.snack).snack-exe;

        # unstable stuff
        brave = unstable.brave;
        idris2 = unstable.idris2;
        ngrok = unstable.ngrok;
        vscodium = unstable.vscodium;
        vscode = unstable.vscode;
        docker-compose = unstable.docker-compose;
        deno = unstable.deno;
        # discord = unstable.discord;
        discord-canary = unstable.discord-canary;
        dotnet-sdk = unstable.dotnet-sdk_5;
        elm-repl = unstable.haskellPackages.elm-repl;
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
