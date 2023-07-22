{ config, lib, pkgs, ... }:
let
  # [Gtkgreet](https://git.sr.ht/~kennylevinsen/gtkgreet) — greetd greeter of choice
  gtkgreet = lib.getExe pkgs.greetd.gtkgreet;

  # [Cage](https://github.com/cage-kiosk/cage) — wayland kiosk
  cage = lib.getExe pkgs.cage;

  dbus-run-session = "${pkgs.dbus}/bin/dbus-run-session";

  kiosk = command:
    "${dbus-run-session} ${cage} -s -- ${command}";

  background = ../../../../common/themes/wallpapers/eye.png;
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # command = kiosk "${gtkgreet} -b ${background}";
        command = ''
          ${lib.getExe pkgs.greetd.tuigreet} \
            -c ${lib.getExe config.programs.hyprland.package} \
            -g "(｡◕‿◕｡) Welcome to tethys!" \
            --remember
            --asterisks
        '';
        user = "adrielus";
      };
    };
  };
}
