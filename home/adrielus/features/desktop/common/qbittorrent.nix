{ pkgs, config, ... }: {
  home.packages = [
    pkgs.qbittorrent
  ];

  home.persistence."/persist/home/adrielus".directories = [
    ".config/qBittorrent" # Config options
    # TODO: investigate which subdirectories/files I actually want to keep
    ".local/share/qBittorrent" # Torrent files, logs, etc 
  ];
}
