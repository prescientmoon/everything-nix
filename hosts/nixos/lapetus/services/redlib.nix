{ config, pkgs, ... }: {
  imports = [ ../../common/optional/services/nginx.nix ];

  services.nginx.virtualHosts."redlib.moonythm.dev" =
    config.satellite.proxy config.services.invidious.port { };

  services.libreddit = {
    enable = true;
    port = 8416;
    package = pkgs.redlib;
  };
}
