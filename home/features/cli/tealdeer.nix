# Example based cli docs
# https://dbrgn.github.io/tealdeer/
{ config, pkgs, ... }: {
  home.packages = [ pkgs.tealdeer ];

  xdg.configFile."tealdeer/config.toml".text = ''
    [updates]
    auto_update = true
  '';

  satellite.persistence.at.cache.apps.tealdeer.directories = [
    "${config.xdg.cacheHome}/tealdeer" # page cache
  ];
}
