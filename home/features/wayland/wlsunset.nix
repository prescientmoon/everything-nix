{ pkgs, lib, ... }:
let
  libnotify = lib.getExe pkgs.libnotify;

  wlsunset-toggle = pkgs.writeShellScriptBin "wlsunset-toggle" ''
    if [ "active" = "$(systemctl --user is-active wlsunset.service)" ]
    then
      systemctl --user stop wlsunset.service
      ${libnotify} "Stopped wlsunset"
    else
      systemctl --user start wlsunset.service
      ${libnotify} "Started wlsunset"
    fi
  '';
in
{
  services.wlsunset = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    # Random Netherlands coordinates
    latitude = "53.2";
    longitude = "6.5";
  };

  home.packages = [ wlsunset-toggle ];
}
