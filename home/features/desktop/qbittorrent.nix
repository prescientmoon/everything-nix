{ pkgs, config, ... }: {
  home.packages = [
    pkgs.qbittorrent
  ];

  satellite.persistence.at.state.apps.QBittorrent.directories = [
    "${config.xdg.configHome}/qBittorrent" # Config options
  ];

  satellite.persistence.at.cache.apps.QBittorrent.directories = [
    # TODO: investigate which subdirectories/files I actually want to keep
    "${config.xdg.dataHome}/qBittorrent" # Torrent files, logs, etc
  ];
}
