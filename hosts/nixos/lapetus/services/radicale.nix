{ config, ... }:
let
  port = 8415;
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

  services.nginx.virtualHosts."cal.moonythm.dev" =
    config.satellite.proxy port { };
}
