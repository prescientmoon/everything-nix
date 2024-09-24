{ config, ... }:
{
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  # {{{ Imports
  imports = [
    ../common/global

    ../common/optional/users/pilot.nix
    ../common/optional/bluetooth.nix
    ../common/optional/greetd.nix
    ../common/optional/oci.nix
    ../common/optional/quietboot.nix

    ../common/optional/desktop
    ../common/optional/desktop/steam.nix
    ../common/optional/wayland/hyprland.nix

    ../common/optional/services/kanata.nix
    ../common/optional/services/nginx.nix
    ../common/optional/services/syncthing.nix
    ../common/optional/services/tailscale.nix
    ../common/optional/services/restic
    ../common/optional/services/iwd

    ./services/snapper.nix

    ./filesystems
    ./hardware
  ];
  # }}}
  # {{{ Machine ids
  networking.hostName = "calypso";
  networking.hostId = "3f69ae4b";
  environment.etc.machine-id.text = "24fe28515de243f6ae4c6aa7e4291aac";
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
  # {{{ A few ad-hoc programs
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;
  # }}}
  # {{{ SSH keys
  users.users.pilot.openssh.authorizedKeys.keyFiles = [ ../tethys/keys/id_ed25519.pub ];
  # }}}

  satellite.pilot.name = "moon";
  boot.loader.systemd-boot.enable = true;
}
