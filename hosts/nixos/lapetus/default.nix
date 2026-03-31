{ config, pkgs, ... }:
{
  imports = [
    ../common

    ./hardware
    ./networking
    ./filesystems

    # ./services/5d-diplomacy (currently broken)
    ./services/actual.nix
    ./services/ddns-updater.nix
    ./services/diptime.nix
    ./services/forgejo.nix
    ./services/glass-server
    ./services/gotosocial.nix
    ./services/grafana.nix
    ./services/homer.nix
    ./services/invidious.nix
    ./services/jellyfin.nix
    ./services/matrix
    ./services/miniflux.nix
    ./services/moonythm.nix
    ./services/picoshare.nix
    ./services/pounce
    ./services/prometheus.nix
    ./services/prometheus.nix
    ./services/qbittorrent.nix
    ./services/radicale.nix
    ./services/redlib.nix
    ./services/shimmeringmoon.nix
    ./services/sillyring.nix
    ./services/syncthing.nix
    ./services/tmp.nix
    ./services/vaultwarden.nix
    ./services/whoogle.nix
    ./services/zfs.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  satellite.pilot.name = "adrielus";
  satellite.machine.interactible = true;
  satellite.containers.enable = true;

  # Machine ids
  networking.hostName = "lapetus";
  networking.hostId = "08357db3";
  environment.etc.machine-id.text = "d9571439c8a34e34b89727b73bad3587";

  # SSH configuration
  users.users.pilot.openssh.authorizedKeys.keyFiles = [
    ../calypso/keys/id_ed25519.pub
    ../tethys/keys/id_ed25519.pub
  ];

  # Trying this out for deployment, although it's a bit scary
  services.openssh.settings.PermitRootLogin = "yes";
  users.users.root.openssh.authorizedKeys.keyFiles =
    config.users.users.pilot.openssh.authorizedKeys.keyFiles;
  services.fail2ban.enable = false;
  satellite.wireless.backend = "iwd";

  # Misc packages
  environment.systemPackages = [
    pkgs.sqlite
    pkgs.git
    pkgs.bat
    pkgs.yazi
  ];

  boot.loader.systemd-boot.enable = true;

  # Tailscale-internal IP DNS records
  satellite.nginx.overlayAddress.ipv4 = "100.93.136.59";
  satellite.nginx.overlayAddress.ipv6 = "fd7a:115c:a1e0::e75d:883b";
}
