{ config, pkgs, ... }: {
  # This is the default port, and can only be changed via the GUI
  satellite.nginx.at.media.port = 8096;
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
