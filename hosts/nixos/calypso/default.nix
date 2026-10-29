{ pkgs, ... }:
{
  system.stateVersion = "24.05";

  imports = [
    ../common
    ../common/desktop/river

    ./hardware
    ./filesystems

    ./services/cgit.nix
    ./services/snapper.nix
    ./services/syncthing.nix
    # ./services/nftables.nix
  ];

  satellite.pilot.name = "moon";
  satellite.machine.graphical = true;
  satellite.machine.gaming = true;

  satellite.wireless.backend = "iwd";
  satellite.river.enable = true;
  satellite.soulseek.enable = true;

  # Machine ids
  networking.hostName = "calypso";
  networking.hostId = "3f69ae4b";
  environment.etc.machine-id.text = "24fe28515de243f6ae4c6aa7e4291aac";

  # SSH keys
  users.users.pilot.openssh.authorizedKeys.keyFiles = [
    ../tethys/keys/id_ed25519.pub
  ];

  # A few ad-hoc options
  boot.loader.systemd-boot.enable = true;

  # Use the latest kernel (the WIFI card is not seen otherwise)
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [ "mt7921_common.disable_clc=1" ];

  # satellite.nginx.at.frog = {
  #   port = 80;
  #   scope = "friends";
  #   vhost = {
  #     root = "/persist/data/frog";
  #     extraConfig = ''
  #       location / {
  #         autoindex on;
  #       }
  #     '';
  #   };
  # };
}
