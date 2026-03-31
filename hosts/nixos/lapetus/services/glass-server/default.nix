{ config, ... }:
let
  port = config.satellite.ports.glass-server;
  dbGlassPort = config.satellite.ports.sqlite-web-glass;
  dbShimmerPort = config.satellite.ports.sqlite-web-shimmer;
in
{
  imports = [ ./module.nix ];

  # {{{ Secrets
  sops.secrets.glass_server_secret_key = {
    owner = config.services.glass-server.user;
    group = config.services.glass-server.user;
    sopsFile = ../../secrets.yaml;
  };

  sops.secrets.glass_server_admin_password = {
    owner = config.services.glass-server.user;
    group = config.services.glass-server.user;
    sopsFile = ../../secrets.yaml;
  };

  sops.secrets.glass_server_admin_token = {
    owner = config.services.glass-server.user;
    group = config.services.glass-server.user;
    sopsFile = ../../secrets.yaml;
  };
  # }}}
  # {{{ Routing
  satellite.nginx.at = rec {
    "a" = arcaea;
    "arcaea" = {
      scope = "public";
      vhost.locations = {
        "/".priority = 2000; # The default is 1000
        "/".proxyPass = "http://localhost:${toString port}/";
        # "/log/".root = "${config.services.glass-server.dataDir}/log/";
        "/db/glass/".proxyPass = # .
          "http://localhost:${toString dbGlassPort}/db/glass/";
        "/db/shimmer/".proxyPass = # .
          "http://localhost:${toString dbShimmerPort}/db/shimmer/";
      };
    };

    "tcp.lp.arcaea" = {
      port = config.satellite.ports.glass-server-lp-tcp;
      scope = "public";
    };

    "udp.lp.arcaea" = {
      port = config.satellite.ports.glass-server-lp-udp;
      scope = "public";
    };
  };

  services.sqliteWeb.databases.glass.urlPrefix = "/db/glass/";
  services.sqliteWeb.databases.shimmer.urlPrefix = "/db/shimmer/";
  # }}}

  services.glass-server = {
    enable = true;
    adminUsername = "prescientmoon";
    dataDir = "/persist/state/var/lib/arcaea/server";

    inherit port;
    linkPlayTCPPort = config.satellite.ports.glass-server-lp-tcp;
    linkPlayUDPPort = config.satellite.ports.glass-server-lp-udp;

    secretKeyFile = config.sops.secrets.glass_server_secret_key.path;
    passwordFile = config.sops.secrets.glass_server_admin_password.path;
    apiTokenFile = config.sops.secrets.glass_server_admin_token.path;
  };
}
