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

  # TODO: consider ssh support
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = pinentry.name;
  };

  programs.gpg = {
    enable = true;
    settings = {
      trust-model = "tofu+pgp";
    };
    # publicKeys = [{
    #   trust = 5;
    # }];
  };
}
