{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ../common/global
    ../common/users/adrielus.nix

    ../common/optional/pipewire.nix
    ../common/optional/touchpad.nix
    ../common/optional/xserver.nix
    ../common/optional/xmonad

    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking.hostName = "tethys";

  # A few ad-hoc settings
  hardware.opengl.enable = true;
  programs.kdeconnect.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
