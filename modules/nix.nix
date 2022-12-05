{ pkgs, inputs, lib, config, ... }: {
  nix = {
    gc.automatic = true;
    optimise.automatic = true;

    # Protect nix-shell from garbage collection
    # TODO: look into whether this is still needed when using nix flakes
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    # nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      trusted-users = [ "root" "adrielus" "@wheel" ];

      auto-optimise-store = true;

      # Caching and whatnot
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cm-idris2-pkgs.cachix.org"
        "https://danth.cachix.org"
        # "https://all-hies.cachix.org" # Do I even use all-hies anymore?
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cm-idris2-pkgs.cachix.org-1:YB2oJSEsD5oMJjAESxolC2GQtE6B5I6jkWhte2gtXjk="
        "danth.cachix.org-1:wpodfSL7suXRc/rJDZZUptMa1t4MJ795hemRN0q84vI="
        # "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
      ];
    };
  };
}
