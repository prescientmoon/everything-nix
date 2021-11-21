{ pkgs, ... }: {
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

    # Emanble nix flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
