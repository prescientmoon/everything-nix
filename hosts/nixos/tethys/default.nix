{ lib, ... }: {
  imports = [
    ../common/global
    ../common/users/adrielus.nix

    ../common/optional/pipewire.nix
    ../common/optional/greetd.nix
    # ../common/optional/xmonad
    # ../common/optional/lightdm.nix
    ../common/optional/steam.nix
    ../common/optional/slambda.nix
    ../common/optional/xdg-portal.nix
    ../common/optional/hyprland.nix
    ../common/optional/quietboot.nix

    ./hardware
    ./services/syncthing.nix
    ./boot.nix
  ];

  # Machine ids
  networking.hostName = "tethys";
  environment.etc.machine-id.text = "08357db3540c4cd2b76d4bb7f825ec88";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  # {{{ A few ad-hoc hardware settings
  hardware.opengl.enable = true;
  hardware.opentabletdriver.enable = true;
  # }}}
  # {{{ A few ad-hoc programs
  programs.kdeconnect.enable = true;
  programs.extra-container.enable = true;
  # }}}
  # {{{ Ad-hoc stylix targets
  # TODO: include this on all gui hosts
  # TODO: is this useful outside of home-manager?
  stylix.targets.gtk.enable = true;
  # }}}
  # {{{ Some ad-hoc site blocking
  networking.extraHosts =
    let
      blacklisted = [ "twitter.com" "minesweeper.online" ];
      blacklist = lib.concatStringsSep "\n" (lib.forEach blacklisted (host: "127.0.0.1 ${host}"));
    in
    blacklist;
  # }}}


}
