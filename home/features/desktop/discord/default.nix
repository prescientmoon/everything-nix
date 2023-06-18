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

  xdg.configFile."discocss/custom.css".source =
    themeMap.${config.lib.stylix.scheme.scheme} or themeMap.default;

  satellite.persistence.at.state.apps.Discord.directories = [
    "${config.xdg.configHome}/discord" # Why tf does discord store it's state here 💀
  ];
}
