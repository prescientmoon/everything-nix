{ pkgs, config, ... }: {
  home.packages = [
    pkgs.lutris
  ];

  # home.persistence."/persist".directories = [
  #   "${config.xdg.configHome}/lutris" # General config data
  #   "${config.xdg.cacheHome}/banners" # Game banners
  #   "${config.xdg.cacheHome}/coverart" # Game cover art
  #   "${config.home.homeDirectory}/Games" # Game directory
  # ];
}
