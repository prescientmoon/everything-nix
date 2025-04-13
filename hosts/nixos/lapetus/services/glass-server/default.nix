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

  services.nginx.virtualHosts."arcaea.moonythm.dev" = {
    locations."/web/".proxyPass =
      "http://localhost:${toString config.satellite.ports.glass-server}/web/";
    locations."/db/glass/".proxyPass =
      "http://localhost:${toString config.satellite.ports.sqlite-web-glass}/db/glass/";
    locations."/db/shimmer/".proxyPass =
      "http://localhost:${toString config.satellite.ports.sqlite-web-shimmer}/db/shimmer/";
    locations."/" = {
      return = "301 https://arcaea.lowiro.com/en";
      priority = 2000; # 1000 is the default for everything else
    };
  };

  satellite.sqliteWeb.databases.glass.location = "/db/glass/";
  satellite.sqliteWeb.databases.shimmer.location = "/db/shimmer/";
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
