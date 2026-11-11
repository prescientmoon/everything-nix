{ pkgs, ... }:
{
  system.stateVersion = "26.05";

  imports = [
    ../common
    ../common/desktop/river

    ./hardware
    ./filesystems

    ./services/snapper.nix
  ];

  satellite.pilot.name = "moon";
  satellite.machine.graphical = true;
  satellite.machine.gaming = true;

  satellite.wireless.backend = "iwd";
  satellite.river.enable = true;
  satellite.soulseek.enable = true;

  networking.hostName = "dione";
  networking.hostId = "43461d8a";
  environment.etc.machine-id.text = "0bcb949174fb4b5eaaffa421bdb66e15";

  users.users.pilot.openssh.authorizedKeys.keyFiles = [
    ../tethys/keys/id_ed25519.pub
  ];

  boot.loader.systemd-boot.enable = true;
}
