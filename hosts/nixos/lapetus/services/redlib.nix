{ config, lib, upkgs, ... }:
let port = config.satellite.ports.redlib;
in
{
  services.libreddit.enable = true;
  satellite.nginx.at.redlib.port = port;
  systemd.services.libreddit.serviceConfig.ExecStart =
    lib.mkForce "${upkgs.redlib}/bin/redlib --port ${toString port}";
}
