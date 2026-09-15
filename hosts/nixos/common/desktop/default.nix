{ config, lib, ... }:
{
  imports = [
    ./quietboot
    ./sway
    ./river
    ./dunst.nix
    ./historia.nix
    ./hyprland.nix
    ./pipewire.nix
    ./steam.nix
    ./unicode.nix
    ./xdg-portal.nix
  ];

  config = lib.mkIf config.satellite.machine.graphical {
    stylix.targets.gtk.enable = true;

    # https://nixos.wiki/wiki/Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
