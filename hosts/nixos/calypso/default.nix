{ pkgs, ... }:
{
  imports = [
    ../common
    ../common/desktop/river

    ./hardware
    ./filesystems

    # ./services/beesd.nix
    ./services/cgit.nix
    ./services/snapper.nix
    ./services/syncthing.nix
    ./services/soulseek.nix
    # ./services/nftables.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  satellite.pilot.name = "moon";
  satellite.machine.graphical = true;
  satellite.machine.gaming = true;

  satellite.wireless.backend = "iwd";
  satellite.qbittorrent.enable = false;
  satellite.river.enable = true;

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
  programs.nix-ld.enable = true; # Useful for running non-nix executables

  services.usbmuxd.enable = true;
  users.users.pilot.extraGroups = [ "adbusers" ];

  # A few gnome thingies
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

  # Use the latest kernel (the WIFI card is not seen otherwise)
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [ "mt7921_common.disable_clc=1" ];
  # boot.kernelPatches = [
  #   {
  #     name = "foo";
  #     patch = ./wg-debug.patch;
  #   }
  # ];

  services.joycond.enable = false; # Toggle when connecting joycons, I guess
  services.blueman.enable = true;

  environment.systemPackages = [
    pkgs.android-tools # adb and the like
  ];

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
