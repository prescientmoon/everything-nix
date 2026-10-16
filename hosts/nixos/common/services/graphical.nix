# Misc defaults for all graphical machines
{ config, lib, pkgs, ...}:
{
  config = lib.mkIf config.satellite.machine.graphical {
    programs.kdeconnect.enable = true;
    programs.firejail.enable = true;
    programs.nix-ld.enable = true; # Useful for running non-nix executables

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.hyprland.enableGnomeKeyring = true;
    services.gnome.evolution-data-server.enable = true;
    services.gnome.gnome-online-accounts.enable = true;

    services.usbmuxd.enable = true;
    users.users.pilot.extraGroups = [ "adbusers" ];

    environment.systemPackages = [
      pkgs.android-tools # adb and the like
    ];

    # Toggle when connecting joycons, I guess
    services.joycond.enable = false;
    services.blueman.enable = false;
  };
}
