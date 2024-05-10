{ lib, pkgs, ... }: {
  # {{{ Imports
  imports = [
    ../common/global
    ../common/users/adrielus.nix

    ../common/optional/pipewire.nix
    ../common/optional/bluetooth.nix
    ../common/optional/greetd.nix
    ../common/optional/quietboot.nix
    ../common/optional/desktop/steam.nix
    ../common/optional/services/kanata.nix
    ../common/optional/desktop/xdg-portal.nix
    ../common/optional/wayland/hyprland.nix

    ./hardware
    ./boot.nix
    ./services/syncthing.nix
    ./services/forgejo.nix
  ];
  # }}}

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  services.mullvad-vpn.enable = true;

  # {{{ Machine ids
  networking.hostName = "tethys";
  environment.etc.machine-id.text = "08357db3540c4cd2b76d4bb7f825ec88";
  # }}}
  # {{{ A few ad-hoc hardware settings
  hardware.enableAllFirmware = true;
  hardware.opengl.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.keyboard.qmk.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  services.tlp.enable = true;
  services.thermald.enable = true;
  # }}}
  # {{{ A few ad-hoc programs
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;
  programs.extra-container.enable = true;
  virtualisation.docker.enable = true;
  # virtualisation.spiceUSBRedirection.enable = true; # This was required for the vm usb passthrough tomfoolery
  # }}}
  # {{{ Ad-hoc stylix targets
  # TODO: include this on all gui hosts
  # TODO: is this useful outside of home-manager?
  stylix.targets.gtk.enable = true;
  # }}}
  # {{{ Some ad-hoc site blocking
  networking.extraHosts =
    let
      blacklisted = [
        # "twitter.com"
        # "www.reddit.com"
        # "minesweeper.online" 
      ];
      blacklist = lib.concatStringsSep "\n" (lib.forEach blacklisted (host: "127.0.0.1 ${host}"));
    in
    blacklist;
  # }}}

  services.mysql = {
    enable = true;
    package = pkgs.mysql80;
  };

  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
}
