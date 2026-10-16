{
  system.stateVersion = "22.11";

  imports = [
    ../common
    ../common/desktop/river

    ./hardware
    ./boot.nix

    ./services/syncthing.nix
  ];

  satellite.pilot.name = "adrielus";
  satellite.machine.graphical = true;
  satellite.machine.gaming = true;

  satellite.wireless.backend = "iwd";
  satellite.river.enable = true;

  # Machine ids
  networking.hostName = "tethys";
  environment.etc.machine-id.text = "08357db3540c4cd2b76d4bb7f825ec88";

  users.users.pilot.openssh.authorizedKeys.keyFiles = [
    ../calypso/keys/id_ed25519.pub
  ];
}
