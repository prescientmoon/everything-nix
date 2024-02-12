{ inputs, config, ... }:
let
  username = "prescientmoon";
  docsHost = "docs.smos.moonythm.dev";
  apiHost = "api.smos.moonythm.dev";
  webHost = "smos.moonythm.dev";
  docsPort = 8404;
  apiPort = 8405;
  webPort = 8406;

  https = host: "https://${host}";
in
{
  imports = [
    ../../common/optional/services/nginx.nix
    inputs.smos.nixosModules.x86_64-linux.default
  ];

  # {{{ Configure smos 
  services.smos.production = {
    enable = true;

    # {{{ Docs server 
    docs-site = {
      enable = true;
      openFirewall = false;
      port = docsPort;
      api-url = https apiHost;
      web-url = https webHost;
    };
    # }}}
    # {{{ Api server
    api-server = {
      enable = true;
      openFirewall = false;
      port = apiPort;
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
      port = webPort;
      docs-url = https docsHost;
      api-url = https apiHost;
      web-url = https webHost;
    };
    # }}}
  };
  # }}}
  # {{{ Networking & storage
  services.nginx.virtualHosts.${docsHost} = config.satellite.proxy docsPort { };
  services.nginx.virtualHosts.${webHost} = config.satellite.proxy webPort { };
  services.nginx.virtualHosts.${apiHost} = config.satellite.proxy apiPort {
    proxyWebsockets = true;

    # Just to make sure we don't run into 413 errors on big syncs
    extraConfig = ''
      client_max_body_size 0;
    '';
  };

  environment.persistence."/persist/state".directories = [
    "/www/smos/production"
  ];
  # }}}
}
