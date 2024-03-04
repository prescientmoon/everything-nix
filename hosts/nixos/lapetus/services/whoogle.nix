{ lib, config, ... }:
let
  port = 8401;
  websiteBlocklist = [
    "www.saashub.com"
    "slant.co"
    "nix-united.com"
    "libhunt.com"
    "www.devopsschool.com"
    "medevel.com"
    "alternativeto.net"
    "linuxiac.com"
    "www.linuxlinks.com"
  ];
in
{
  imports = [
    ../../common/optional/podman.nix
    ../../common/optional/services/nginx.nix
  ];

  virtualisation.oci-containers.containers.whoogle-search = {
    image = "benbusby/whoogle-search";
    autoStart = true;
    ports = [ "${toString port}:5000" ]; # server:docker
    environment = {
      WHOOGLE_UPDATE_CHECK = "0";
      WHOOGLE_CONFIG_DISABLE = "0";
      WHOOGLE_CONFIG_BLOCK = lib.concatStringsSep "," websiteBlocklist;
      WHOOGLE_CONFIG_THEME = "system";
    };
  };

  services.nginx.virtualHosts."search.moonythm.dev" = config.satellite.proxy port { };
}
