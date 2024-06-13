{ config, ... }:
let
  port = config.satellite.ports.radicale;
  dataDir = "/persist/data/radicale";
in
{
  services.radicale = {
    enable = true;

    settings = {
      server.hosts = [ "localhost:${toString port}" ];
      storage.filesystem_folder = dataDir;
    };
  };

  systemd.tmpfiles.rules = [ "d ${dataDir} 0700 radicale radicale" ];
  satellite.nginx.at.cal.port = port;
}
