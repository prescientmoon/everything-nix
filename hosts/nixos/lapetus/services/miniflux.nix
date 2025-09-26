{ config, ... }:
{
  sops.secrets.miniflux_admin_credentials.sopsFile = ../secrets.yaml;
  satellite.nginx.at.miniflux.port = config.satellite.ports.miniflux;
  satellite.nginx.at.miniflux.subdomain = "rss";

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets.miniflux_admin_credentials.path;
    config = {
      BASE_URL = config.satellite.nginx.at.miniflux.url;
      LISTEN_ADDR = "127.0.0.1:${toString config.satellite.ports.miniflux}";

      # Never delete posts
      CLEANUP_ARCHIVE_READ_DAYS = -1;
      CLEANUP_ARCHIVE_UNREAD_DAYS = -1;
    };
  };
}
