{
  imports = [
    ../common/global
    ../common/users/pilot.nix
    ../common/optional/oci.nix
    ../common/optional/services/acme.nix
    ../common/optional/services/kanata.nix
    ../common/optional/services/nginx.nix
    ../common/optional/services/postgres.nix
    ../common/optional/services/restic

    # ./services/commafeed.nix
    # ./services/ddclient.nix
    ./services/actual.nix
    ./services/cloudflared.nix
    ./services/diptime.nix
    ./services/forgejo.nix
    ./services/grafana.nix
    ./services/guacamole
    ./services/homer.nix
    ./services/intray.nix
    ./services/invidious.nix
    ./services/jellyfin.nix
    ./services/jupyter.nix
    ./services/microbin.nix
    ./services/pounce.nix
    ./services/prometheus.nix
    ./services/prometheus.nix
    ./services/qbittorrent.nix # turned on/off depending on whether my vpn is paid for
    ./services/radicale.nix
    ./services/redlib.nix
    ./services/smos.nix
    ./services/syncthing.nix
    ./services/vaultwarden.nix
    ./services/whoogle.nix
    ./services/zfs.nix

    ./filesystems
    ./hardware
  ];

  # Machine ids
  networking.hostName = "lapetus";
  networking.hostId = "08357db3";
  environment.etc.machine-id.text = "d9571439c8a34e34b89727b73bad3587";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
}
