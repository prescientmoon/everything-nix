{ config, ... }:
let
  port = config.satellite.ports.redlib;
in
{
  services.redlib.enable = true;
  services.redlib.address = "127.0.0.1";
  satellite.nginx.at.redlib.port = port;
}
