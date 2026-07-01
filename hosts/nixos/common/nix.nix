{
  config,
  lib,
  upkgs,
  inputs,
  ...
}:
{
  nix = {
    package = upkgs.lix;

    # Clean up the store weekly
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
        "auto-allocate-uids"
      ];

      # Disable warning when rebuilding before committing
      warn-dirty = false;

      # De-duplicate and optimize nix store
      auto-optimise-store = true;
    };
  };
}
