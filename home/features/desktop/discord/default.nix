{ config, pkgs, ... }:
let
in
# themeMap = pkgs.callPackage (import ./themes.nix) { };
{
  programs.discord = {
    enable = true;
    package = pkgs.vesktop;
    settings.DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
  };

  home.packages = [ pkgs.discord ];

  # xdg.configFile."discocss/custom.css".source = config.satellite.theming.get themeMap;

  # Clean cache older than 10 days
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.configHome}/discord/Cache/Cache_Data - - - 10d"
    "d ${config.xdg.configHome}/vesktop/sessionData/Cache/Cache_Data - - - 10d"
  ];

  satellite.persistence.at.state.apps.discord.directories = [
    "${config.xdg.configHome}/discord" # Why tf does discord store its state here 💀
    "${config.xdg.configHome}/vesktop"
  ];
}
