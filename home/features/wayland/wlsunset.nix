{ pkgs, ... }:
let
  systemctl = "${pkgs.systemd}/bin/systemctl";

  wlsunset-toggle = pkgs.writeShellScriptBin "wlsunset-toggle" ''
    if [ "active" = "$(systemctl --user is-active wlsunset.service)" ]
    then
      ${systemctl} --user stop wlsunset.service
      echo "Stopped wlsunset"
    else
      ${systemctl} --user start wlsunset.service
      echo "Started wlsunset"
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
