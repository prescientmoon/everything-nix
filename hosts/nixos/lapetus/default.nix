{ config, ... }:
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
    ../common/optional/services/kanata.nix
    ../common/optional/services/nginx.nix
    ../common/optional/services/postgres.nix
    ../common/optional/services/syncthing.nix
    ../common/optional/services/restic
    ../common/optional/services/wpa_supplicant.nix

    # ./services/commafeed.nix
    # ./services/ddclient.nix
    # ./services/guacamole
    # ./services/intray.nix
    # ./services/smos.nix
    ./services/5d-diplomacy
    ./services/actual.nix
    ./services/cloudflared.nix
    ./services/diptime.nix
    ./services/forgejo.nix
    ./services/grafana.nix
    ./services/homer.nix
    ./services/invidious.nix
    ./services/jellyfin.nix
    ./services/jupyter.nix
    ./services/microbin.nix
    ./services/pounce.nix
    ./services/prometheus.nix
    ./services/prometheus.nix
    ./services/qbittorrent.nix
    ./services/radicale.nix
    ./services/redlib.nix
    ./services/vaultwarden.nix
    ./services/whoogle.nix
    ./services/zfs.nix

    ./filesystems
    ./hardware
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

  users.users.root.openssh.authorizedKeys.keyFiles =
    config.users.users.pilot.openssh.authorizedKeys.keyFiles;
  # }}}

  boot.loader.systemd-boot.enable = true;
}
