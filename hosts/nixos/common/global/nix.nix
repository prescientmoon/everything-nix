{ config, lib, pkgs, inputs, ... }: {
  nix = {
    # Flake support and whatnot
    package = pkgs.nixUnstable;

    # Weekly clean up the store, I think
    gc = {
      automatic = true;
      dates = "weekly";
    };

    # ~~Protect nix shell from garbage collection~~
    # This was taking too much storage
    # extraOptions = ''
    #   keep-outputs = true
    #   keep-derivations = true
    # '';

    # https://nixos.wiki/wiki/Storage_optimization
    optimise.automatic = true;

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
        "auto-allocate-uids"
        # "configurable-impure-env"
      ];

      # Disable warning when rebuilding before commiting
      warn-dirty = false;

      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      # TODO: what is a trusted user?
      trusted-users = [ "root" "@wheel" ];
    };
  };
}
