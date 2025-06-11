{ config, ... }:
let
  port = config.satellite.ports.radicale;
  dataDir = "/persist/data/radicale";
in
{
  sops.secrets.radicale_auth = {
    sopsFile = ../secrets.yaml;
    owner = config.systemd.services.radicale.serviceConfig.User;
    group = config.systemd.services.radicale.serviceConfig.Group;
  };

  services.radicale = {
    enable = true;

    settings = {
      server.hosts = [ "localhost:${toString port}" ];
      storage.filesystem_folder = dataDir;

      auth = {
        type = "htpasswd";
        htpasswd_filename = config.sops.secrets.radicale_auth.path;
        htpasswd_encryption = "autodetect";
      };
    };
  };

  systemd.tmpfiles.rules = [ "d ${dataDir} 0700 radicale radicale" ];
  satellite.nginx.at.cal.port = port;
}
