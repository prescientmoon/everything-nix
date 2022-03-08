{ pkgs, ... }:
let
  shellAliases = import ./aliases.nix;
  common = import ./common.nix;
in
{
  home-manager.users.adrielus.programs.fish = {
    inherit shellAliases;

    shellInit = ''
      source ${../../../dotfiles/fish/fish.conf}
    '' ++ common.shellInit;

    plugins = with pkgs; [ myFishPlugins.z myFishPlugins.vi-mode myFishPlugins.themes.agnoster ];

    enable = true;
  };
}
