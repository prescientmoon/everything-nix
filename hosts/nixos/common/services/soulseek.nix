{ config, lib, ... }:
let
  cfg = config.satellite.soulseek;
  scfg = config.services.slskd;
in
{
  options.satellite.soulseek = {
    enable = lib.mkEnableOption "satellite's soulseek integration";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.soulseeker_env = {
      sopsFile = ../secrets.yaml;
      owner = scfg.user;
      group = scfg.group;
    };

    satellite.nginx.at."soul.${config.networking.hostName}".port = # .
      config.satellite.ports.soulseek-web;

    services.slskd = {
      enable = true;
      domain = null; # We configure Nginx ourselves
      user = config.satellite.pilot.name;
      environmentFile = config.sops.secrets.soulseeker_env.path;
      settings = {
        remote_file_management = true;

        soulseek.listen_port = config.satellite.ports.soulseek;
        web.port = config.satellite.ports.soulseek-web;

        directories = {
          incomplete = "/var/lib/slskd/incomplete";
          downloads = "/var/lib/slskd/downloads";
        };

        shares.directories = [
          "/persist/data${config.users.users.pilot.home}/media/music/pebbles"
        ];
      };
    };

    satellite.persistence.at.state.on."/var/lib".on.slskd = {
      permissions = { inherit (scfg) group user; };
      directories = [ "data" ];
    };

    satellite.persistence.at.cache.on."/var/lib".on.slskd = {
      permissions = { inherit (scfg) group user; };
      directories = [ "incomplete" "downloads" ];
    };
  };
}
