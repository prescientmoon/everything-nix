{ config, pkgs, ... }:
{
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  # {{{ Imports
  imports = [
    ../common/global
    ../common/optional/users/pilot.nix
    ../common/optional/oci.nix
    ../common/optional/services/tailscale.nix
    ../common/optional/services/acme.nix
    ../common/optional/services/nginx.nix
    ../common/optional/services/postgres.nix
    ../common/optional/services/syncthing.nix
    ../common/optional/services/restic

    ./services/5d-diplomacy
    ./services/actual.nix
    ./services/cloudflared.nix
    ./services/diptime.nix
    ./services/forgejo.nix
    ./services/glass-server
    ./services/grafana.nix
    ./services/homer.nix
    ./services/invidious.nix
    ./services/jellyfin.nix
    ./services/matrix
    ./services/microbin.nix
    ./services/miniflux.nix
    ./services/moonythm.nix
    ./services/pounce.nix
    ./services/prometheus.nix
    ./services/prometheus.nix
    ./services/qbittorrent.nix
    ./services/radicale.nix
    ./services/redlib.nix
    ./services/shimmeringmoon.nix
    ./services/sillyring.nix
    ./services/vaultwarden.nix
    ./services/whoogle.nix
    ./services/zfs.nix

    ./filesystems
    ./hardware
    ./networking
  ];
  # }}}
  # {{{ Machine ids
  networking.hostName = "lapetus";
  networking.hostId = "08357db3";
  environment.etc.machine-id.text = "d9571439c8a34e34b89727b73bad3587";
  # }}}
  # {{{ Tailscale internal IP DNS records
  satellite.dns.records = [
    {
      at = config.networking.hostName;
      type = "A";
      value = "100.93.136.59";
    }
    {
      at = config.networking.hostName;
      type = "AAAA";
      value = "fd7a:115c:a1e0::e75d:883b";
    }
  ];
  # }}}
  # {{{ SSH keys
  users.users.pilot.openssh.authorizedKeys.keyFiles = [
    ../calypso/keys/id_ed25519.pub
    ../tethys/keys/id_ed25519.pub
  ];

  # Trying this out for deployment, although it's a bit scary
  services.openssh.settings.PermitRootLogin = "yes";
  users.users.root.openssh.authorizedKeys.keyFiles =
    config.users.users.pilot.openssh.authorizedKeys.keyFiles;
  services.fail2ban.enable = false;
  # }}}
  # {{{ Misc packages
  environment.systemPackages = [
    pkgs.sqlite
    pkgs.git
    pkgs.bat
    pkgs.yazi
  ];
  # }}}

  boot.loader.systemd-boot.enable = true;
}
