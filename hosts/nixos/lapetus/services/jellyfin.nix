{ config, pkgs, ... }: {
  imports = [ ../../common/optional/services/nginx.nix ];

  services.nginx.virtualHosts."media.moonythm.dev" =
    config.satellite.proxy 8096 { }; # This is the default port, and can only be changed via the GUI

  services.jellyfin.enable = true;

  # {{{ Storage 
  environment.persistence."/persist/state".directories = [{
    directory = "/var/lib/jellyfin";
    mode = "u=rwx,g=r,o=r";
    user = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
  }];

  environment.persistence."/persist/local/cache".directories = [{
    directory = "/var/cache/jellyfin";
    mode = "u=rwx,g=,o=";
    user = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
  }];
  # }}}
}
