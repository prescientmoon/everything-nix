{ inputs, config, ... }:
let username = "prescientmoon";
in
{
  imports = [ inputs.smos.nixosModules.x86_64-linux.default ];

  # {{{ Configure smos 
  services.smos.production = {
    enable = true;

    # {{{ Docs server 
    docs-site = {
      enable = true;
      openFirewall = false;
      port = config.satellite.nginx.at."docs.smos".port;
      api-url = config.satellite.nginx.at."api.smos".url;
      web-url = config.satellite.nginx.at."smos".url;
    };
    # }}}
    # {{{ Api server
    api-server = {
      enable = true;
      openFirewall = false;
      port = config.satellite.nginx.at."api.smos".port;
      admin = username;

      max-backups-per-user = 5;
      backup-interval = 3600;
      local-backup.enable = true;
    };
    # }}}
    # {{{ Web server
    web-server = {
      enable = true;
      openFirewall = false;
      port = config.satellite.nginx.at."smos".port;
      docs-url = config.satellite.nginx.at."docs.smos".url;
      api-url = config.satellite.nginx.at."api.smos".url;
      web-url = config.satellite.nginx.at."smos".url;
    };
    # }}}
  };
  # }}}
  # {{{ Networking & storage
  satellite.nginx.at."docs.smos".port = config.satellite.ports.smos-docs;
  satellite.nginx.at."api.smos".port = config.satellite.ports.smos-api;
  satellite.nginx.at."smos".port = config.satellite.ports.smos-client;

  environment.persistence."/persist/state".directories = [
    "/www/smos/production"
  ];
  # }}}
}
