{
  imports = [
    ../common
    ./hardware
    ./boot.nix

    ./services/syncthing.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  satellite.pilot.name = "adrielus";
  satellite.machine.graphical = true;
  satellite.machine.gaming = true;

  satellite.wireless.backend = "iwd";
  satellite.hyprland.enable = true;
  satellite.mullvad.enable = false;

  # Machine ids
  networking.hostName = "tethys";
  environment.etc.machine-id.text = "08357db3540c4cd2b76d4bb7f825ec88";

  # A few ad-hoc options
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

  users.users.pilot.openssh.authorizedKeys.keyFiles = [
    ../calypso/keys/id_ed25519.pub
  ];
}
