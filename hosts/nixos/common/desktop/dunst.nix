{ config, lib, ... }:
{
  config = lib.mkIf config.satellite.machine.graphical {
    services.dunst.enable = true;
  };
}
