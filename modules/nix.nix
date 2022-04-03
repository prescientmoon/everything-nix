{ pkgs, ... }: {
  nix = {
    trustedUsers = [ "root" "adrielus" "@wheel" ];
    autoOptimiseStore = true;
    optimise.automatic = true;
    gc.automatic = false;

    # Emanble nix flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Caching and whatnot
    binaryCaches = [
      "https://nix-community.cachix.org"
      "https://cm-idris2-pkgs.cachix.org"
      "https://cache.nixos.org"
      "https://all-hies.cachix.org" # Do I even use all-hies anymore?
    ];

    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cm-idris2-pkgs.cachix.org-1:YB2oJSEsD5oMJjAESxolC2GQtE6B5I6jkWhte2gtXjk="
      "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
    ];
  };
}
