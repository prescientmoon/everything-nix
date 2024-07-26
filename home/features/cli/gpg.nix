{ pkgs, config, ... }:
{
  services.gpg-agent = {
    enable = true;
    pinentryPackage =
      if config.gtk.enable
      then pkgs.pinentry-gnome3
      else pkgs.pinentry-curses;
  };

  programs.gpg.enable = true;

  satellite.persistence.at.state.apps.gpg.directories = [ ".gnupg" ];
}
