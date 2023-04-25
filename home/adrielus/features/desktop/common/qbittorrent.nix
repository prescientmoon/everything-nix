{ pkgs, config, ... }: {
  home.packages = [
    pkgs.qbittorrent
  ];

  # home.persistence."/persist".directories = [
  #   "${config.xdg.configHome}/qBittorrent" # Config options
  #   # TODO: investigate which subdirectories/files I actually want to keep
  #   "${config.xdg.dataHome}/qBittorrent" # Torrent files, logs, etc 
  # ];
}
