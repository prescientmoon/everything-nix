{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ../common/global
    ../common/users/adrielus.nix

    ../common/optional/pipewire.nix
    ../common/optional/touchpad.nix
    ../common/optional/xserver.nix
    ../common/optional/lightdm.nix
    ../common/optional/xmonad
    ../common/optional/slambda.nix

    ./hardware-configuration.nix
    ./boot.nix
  ];

  # Set the name of this machine!
  networking.hostName = "tethys";

  # A few ad-hoc settings
  hardware.opengl.enable = true;
  programs.kdeconnect.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  # Temp stuff:
  containers.euporie = import ../euoprie;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
