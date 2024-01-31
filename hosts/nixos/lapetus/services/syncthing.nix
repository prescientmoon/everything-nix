{ config, ... }:
let port = 8384;
in
{
  imports = [ ../../common/optional/services/syncthing.nix ];

  services.syncthing = {
    settings.folders = { };
    guiAddress = "127.0.0.1:${toString port}";
    settings.gui.insecureSkipHostcheck = true;
  };

  services.nginx.virtualHosts."lapetus.syncthing.moonythm.dev" = config.satellite.proxy port;
}
