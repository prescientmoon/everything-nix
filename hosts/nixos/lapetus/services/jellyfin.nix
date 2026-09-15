{ config, ... }:
{
  # This is the default port, and can only be changed via the GUI
  satellite.nginx.at.media.port = 8096;
  services.jellyfin = rec {
    enable = true;
    cacheDir = "/persist/local/cache/var/cache/jellyfin";
    logDir = "${cacheDir}/log";
    dataDir = "/persist/state/var/lib/jellyfin";
  };
}
