{ config, ... }:
let
  port = config.satellite.ports.redlib;
in
{
  services.redlib.enable = true;
  satellite.nginx.at.redlib.port = port;
}
