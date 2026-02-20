{ config, ... }:
{
  satellite.qbittorrent.enable = true;
  satellite.nginx.at.qbit.port = config.satellite.ports.qbittorrent;
}
