{ config, ... }:
{
  # Makes bluetooth media controls work
  services.mpris-proxy.enable = true;
  services.playerctld.enable = true;
  home.packages = [ config.services.playerctld.package ];
}
