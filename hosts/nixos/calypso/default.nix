{
  config,
  pkgs,
  upkgs,
  ...
}:
{
  imports = [
    ../common

    ./hardware
    ./filesystems

    ./services/beesd.nix
    ./services/cgit.nix
    ./services/snapper.nix
    ./services/syncthing.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  satellite.pilot.name = "moon";
  satellite.machine.graphical = true;
  satellite.machine.gaming = true;

  satellite.wireless.backend = "iwd";
  satellite.hyprland.enable = true;
  satellite.greetd.enable = true;
  satellite.qbittorrent.enable = false;

  # Machine ids
  networking.hostName = "calypso";
  networking.hostId = "3f69ae4b";
  environment.etc.machine-id.text = "24fe28515de243f6ae4c6aa7e4291aac";

  # SSH keys
  users.users.pilot.openssh.authorizedKeys.keyFiles = [
    ../tethys/keys/id_ed25519.pub
  ];

  # A few ad hoc options
  boot.loader.systemd-boot.enable = true;
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;
  services.mullvad-vpn.enable = true;
  programs.nix-ld.enable = true; # Useful for running non-nix executables

  services.usbmuxd.enable = true;
  programs.adb.enable = true;
  users.users.pilot.extraGroups = [ "adbusers" ];

  # A few gnome thingies
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

  # Use the latest kernel (the WIFI card is not seen otherwise)
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [ "mt7921_common.disable_clc=1" ];

  # Tailscale-internal IP DNS records
  satellite.dns.records = [
    {
      at = config.networking.hostName;
      type = "A";
      value = "100.74.40.5";
    }
    {
      at = config.networking.hostName;
      type = "AAAA";
      value = "fd7a:115c:a1e0::1201:2806";
    }
  ];

  # Waydroid
  virtualisation.waydroid.enable = true;
  environment.systemPackages = [ upkgs.waydroid-helper ];
  systemd = {
    packages = [ upkgs.waydroid-helper ];
    services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  };

  # TEMPORARY
  # services.nginx.virtualHosts."frog.moonythm.dev" = {
  #   root = "/persist/data/frog";
  #   extraConfig = ''
  #     location / {
  #       autoindex on;
  #     }
  #   '';
  # };
  #
  # satellite.cloudflared.at.frog.port = 80;
  #
  # sops.secrets.cloudflare_tunnel_credentials.sopsFile = ./secrets.yaml;
  # satellite.cloudflared = {
  #   enable = true;
  #   tunnel = "347d9ead-a523-4f8b-bca7-3066e31e2952";
  #   credentialsFile = config.sops.secrets.cloudflare_tunnel_credentials.path;
  # };
}
