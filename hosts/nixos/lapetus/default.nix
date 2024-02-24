{
  imports = [
    ../common/global
    ../common/users/adrielus.nix
    ../common/optional/services/kanata.nix

    ./services/syncthing.nix
    ./services/whoogle.nix
    ./services/pounce.nix
    ./services/intray.nix
    ./services/smos.nix
    ./services/vaultwarden.nix
    ./services/actual.nix
    ./services/homer.nix
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
