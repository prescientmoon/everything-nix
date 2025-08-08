{ config, ... }:
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
  satellite.cloudflared.at."tcp.lp.arcaea".port = config.satellite.ports.glass-server-lp-tcp;
  satellite.cloudflared.at."udp.lp.arcaea".port = config.satellite.ports.glass-server-lp-udp;

  satellite.cloudflared.at.arcaea.port = 80;
  satellite.cloudflared.at.a.port = 80;

  services.nginx.virtualHosts =
    let
      routing = {
        locations."/".priority = 2000; # The default is 1000
        locations."/".proxyPass = "http://localhost:${toString config.satellite.ports.glass-server}/";

        locations."/db/glass/".proxyPass =
          "http://localhost:${toString config.satellite.ports.sqlite-web-glass}/db/glass/";
        locations."/db/shimmer/".proxyPass =
          "http://localhost:${toString config.satellite.ports.sqlite-web-shimmer}/db/shimmer/";
        locations."/log/".root = "${config.services.glass-server.dataDir}/log/";
      };
    in
    {
      "arcaea.moonythm.dev" = routing;
      "a.moonythm.dev" = routing;
    };

  services.sqliteWeb.databases.glass.urlPrefix = "/db/glass/";
  services.sqliteWeb.databases.shimmer.urlPrefix = "/db/shimmer/";
  # }}}

  services.glass-server = {
    enable = true;
    adminUsername = "prescientmoon";
    dataDir = "/persist/state/var/lib/arcaea/server";

    port = config.satellite.ports.glass-server;
    linkPlayTCPPort = config.satellite.ports.glass-server-lp-tcp;
    linkPlayUDPPort = config.satellite.ports.glass-server-lp-udp;

    secretKeyFile = config.sops.secrets.glass_server_secret_key.path;
    passwordFile = config.sops.secrets.glass_server_admin_password.path;
    apiTokenFile = config.sops.secrets.glass_server_admin_token.path;
  };
}
