{ config, ... }:
{
  imports = [
    ../common
    ./services/syncthing.nix
    ./hardware
    ./boot.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  satellite.pilot.name = "adrielus";
  satellite.machine.graphical = true;
  satellite.machine.gaming = true;
  satellite.wireless.backend = "wpa-supplicant";
  satellite.hyprland.enable = true;

  # Machine ids
  networking.hostName = "tethys";
  environment.etc.machine-id.text = "08357db3540c4cd2b76d4bb7f825ec88";

  # A few ad-hoc options
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;
  services.mullvad-vpn.enable = true;
  stylix.targets.gtk.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

  users.users.pilot.openssh.authorizedKeys.keyFiles = [
    ../calypso/keys/id_ed25519.pub
  ];

  # Tailscale-internal IP DNS records
  satellite.nginx.overlayAddress.ipv4 = "100.91.10.131";
  satellite.nginx.overlayAddress.ipv6 = "fd7a:115c:a1e0:ab12:4843:cd96:625b:a83";
}
