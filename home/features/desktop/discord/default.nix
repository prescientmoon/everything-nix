{ config, pkgs, ... }:
let
  themeMap = pkgs.callPackage (import ./themes.nix) { };
in
{
  programs.discord = {
    enable = true;
    enableOpenASAR = false;
    disableUpdateCheck = true;
    enableDevtools = true;
  };

  home.packages = [ pkgs.discocss ];
  xdg.configFile."discocss/custom.css".source = config.satellite.theming.get themeMap;

  satellite.persistence.at.state.apps.Discord.directories = [
    "${config.xdg.configHome}/discord" # Why tf does discord store it's state here 💀
  ];
}
