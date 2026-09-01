{ config, lib, ... }:
{
  imports = [
    ./quietboot
    ./pipewire.nix
    ./xdg-portal.nix
    ./steam.nix
    ./unicode.nix
    ./hyprland.nix
    ./historia.nix
  ];

  config = lib.mkIf config.satellite.machine.graphical {
    stylix.targets.gtk.enable = true;

    # https://nixos.wiki/wiki/Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
