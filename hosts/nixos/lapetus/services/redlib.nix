{ config, lib, upkgs, ... }:
let port = 8416;
in
{
  imports = [ ../../common/optional/services/nginx.nix ];

  services.nginx.virtualHosts."redlib.moonythm.dev" =
    config.satellite.proxy port { };

  services.libreddit.enable = true;
  systemd.services.libreddit.serviceConfig.ExecStart =
    lib.mkForce "${upkgs.redlib}/bin/redlib --port ${toString port}";
}
