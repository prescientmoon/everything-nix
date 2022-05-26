{ pkgs, ... }: {
  #  Idk why tf I need to add this here
  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-12.22.12"
  ];

  home-manager.users.adrielus = {
    nixpkgs.config.permittedInsecurePackages = [
      "nodejs-12.22.12"
    ];
  };

  nix = {
    # Emanble nix flakes
    package = pkgs.nixFlakes;

    trustedUsers = [ "root" "adrielus" "@wheel" ];

    autoOptimiseStore = true;
    optimise.automatic = true;
    gc.automatic = true;

    # Protect nix-shell from garbage collection
    # TODO: look into whether this is still needed when using nix flakes
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    # Caching and whatnot
    binaryCaches = [
      "https://nix-community.cachix.org"
      "https://cm-idris2-pkgs.cachix.org"
      "https://cache.nixos.org"
      # "https://all-hies.cachix.org" # Do I even use all-hies anymore?
    ];

    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cm-idris2-pkgs.cachix.org-1:YB2oJSEsD5oMJjAESxolC2GQtE6B5I6jkWhte2gtXjk="
      # "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
    ];
  };
}
