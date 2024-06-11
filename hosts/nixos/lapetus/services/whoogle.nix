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
    "sourceforge.net"
  ];
in
{
  imports = [
    ../../common/optional/services/nginx.nix
    ../../common/optional/oci.nix
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
      WHOOGLE_ALT_WIKI = ""; # disable redirecting wikipedia links
      WHOOGLE_ALT_RD = "redlib.moonythm.dev";
      WHOOGLE_ALT_YT = "yt.moonythm.dev";
    };
  };

  services.nginx.virtualHosts."search.moonythm.dev" = config.satellite.proxy port { };
}
