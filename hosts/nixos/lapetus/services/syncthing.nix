{ config, ... }:
let port = 8384;
in
{
  services.syncthing = {
    settings.folders = { };
    guiAddress = "127.0.0.1:${toString port}";
    settings.gui.insecureSkipHostcheck = true;
  };

  satellite.nginx.at."lapetus.syncthing".port = port;
}
