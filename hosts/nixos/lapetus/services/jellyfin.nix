{ config, pkgs, ... }: {
  # This is the default port, and can only be changed via the GUI
  satellite.nginx.at.media.port = 8096;
  services.jellyfin.enable = true;

  # {{{ Storage 
  environment.persistence."/persist/state".directories = [{
    inherit (config.services.jellyfin) user group;
    directory = "/var/lib/jellyfin";
    mode = "u=rwx,g=r,o=r";
  }];

  environment.persistence."/persist/local/cache".directories = [{
    inherit (config.services.jellyfin) user group;
    directory = "/var/cache/jellyfin";
    mode = "u=rwx,g=,o=";
  }];
  # }}}
}
