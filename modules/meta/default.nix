{ pkgs, ... }: {
  home-manager.sharedModules = [ ./simlink.nix ];
}
