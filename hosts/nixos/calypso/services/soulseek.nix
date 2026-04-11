{ config, ... }:
let
  cfg = config.services.slskd;
in
{
  sops.secrets.soulseeker_env = {
    sopsFile = ../secrets.yaml;
    owner = cfg.user;
    group = cfg.group;
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

  systemd.tmpfiles.rules = [
    "d ${cfg.settings.directories.downloads}  0755 ${cfg.user} ${cfg.group}"
    "d ${cfg.settings.directories.incomplete} 0755 ${cfg.user} ${cfg.group}"
  ];

  environment.persistence."/persist/state".directories = [
    {
      inherit (cfg) group user;
      directory = "/var/lib/soulseek";
    }
  ];
}
