{ pkgs, ... }:
{
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  # {{{ Imports
  imports = [
    ../common/global
    ../common/users/pilot.nix

    ../common/optional/bluetooth.nix
    ../common/optional/greetd.nix
    ../common/optional/oci.nix
    ../common/optional/quietboot.nix

    ../common/optional/desktop
    ../common/optional/desktop/steam.nix
    ../common/optional/wayland/hyprland.nix

    ../common/optional/services/tailscale.nix
    ../common/optional/services/kanata.nix
    ../common/optional/services/restic
    ../common/optional/services/nginx.nix
    ./services/syncthing.nix

    ./hardware
    ./boot.nix
  ];
  # }}}
  # {{{ Machine ids
  networking.hostName = "tethys";
  environment.etc.machine-id.text = "08357db3540c4cd2b76d4bb7f825ec88";
  # }}}
  # {{{ A few ad-hoc programs
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;
  services.mullvad-vpn.enable = true;

  services.mysql = {
    enable = true;
    package = pkgs.mysql80;
  };
  # }}}
  # {{{ Ad-hoc stylix targets
  stylix.targets.gtk.enable = true;
  # }}}
  # {{{ Tailscale internal IP DNS records
  satellite.dns.records = [
    # {
    #   at = config.networking.hostName;
    #   type = "A";
    #   value = "100.93.136.59";
    # }
    # {
    #   at = config.networking.hostName;
    #   type = "AAAA";
    #   value = "fd7a:115c:a1e0::e75d:883b";
    # }
  ];
  # }}}
}
