{ config, lib, ... }:
{
  imports = [
    ./quietboot
    # ./river <- The fact this uses HM causes issues...
    ./dunst.nix
    ./historia.nix
    ./pipewire.nix
    ./steam.nix
    ./unicode.nix
  ];

  config = lib.mkIf config.satellite.machine.graphical {
    stylix.targets.gtk.enable = true;

    # https://nixos.wiki/wiki/Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
