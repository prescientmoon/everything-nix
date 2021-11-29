{ pkgs, ... }:
let
  shellAliases = import ./aliases.nix;
  common = import ./common.nix;
in {
  home-manager.users.adrielus.programs.fish = {
    inherit shellAliases;
    shellInit = common.shellInit;
    plugins = [ fishPlugins.z fishThemes.agnoster ];

    enable = true;
  };
}
