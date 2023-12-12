{ pkgs, config, ... }:
let
  pinentry =
    if config.gtk.enable then {
      packages = [ pkgs.pinentry-gnome pkgs.gcr ];
      name = "gnome3";
    } else {
      packages = [ pkgs.pinentry-curses ];
      name = "curses";
    };
in
{
  home.packages = pinentry.packages;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = pinentry.name;
  };

  programs.gpg.enable = true;

  satellite.persistence.at.state.apps.gpg.directories = [ ".gnupg" ];
}
