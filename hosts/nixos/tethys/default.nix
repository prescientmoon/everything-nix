{
  imports = [
    ../common/global
    ../common/users/adrielus.nix

    ../common/optional/pipewire.nix
    ../common/optional/touchpad.nix
    ../common/optional/xserver.nix
    ../common/optional/lightdm.nix
    ../common/optional/steam.nix
    ../common/optional/slambda.nix
    ../common/optional/xdg-portal.nix
    ../common/optional/hyprland.nix
    ../common/optional/xmonad

    ./hardware-configuration.nix
    ./boot.nix
  ];

  # Set the name of this machine!
  networking.hostName = "tethys";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  # {{{ A few ad-hoc hardware settings
  hardware.opengl.enable = true;
  # TODO: persistence of config 
  hardware.opentabletdriver.enable = true;
  # }}}
  # {{{ A few ad-hoc programs
  programs.kdeconnect.enable = true;
  programs.extra-container.enable = true;
  # }}}
  # {{{ Ad-hoc stylix targets
  # TODO: include this on all gui hosts
  stylix.targets.gtk.enable = true;
  # }}}
}
