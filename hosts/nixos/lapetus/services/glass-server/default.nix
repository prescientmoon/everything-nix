{ pkgs, config, ... }:
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

  sops.templates.glass-server-config = {
    owner = config.services.glass-server.user;
    group = config.services.glass-server.user;
    content = builtins.toJSON {
      CONTENT_BUNDLE_FOLDER_PATH = "${pkgs.shimmeringextra}/bundles";
      SECRET_KEY = "${config.sops.placeholder.glass_server_secret_key}";
      PASSWORD = "${config.sops.placeholder.glass_server_admin_password}";
      API_TOKEN = "${config.sops.placeholder.glass_server_admin_token}";
    };
  };
  # }}}

  satellite.cloudflared.at.arcaea.port = config.satellite.ports.glass-server;
  satellite.cloudflared.at."tcp.lp.arcaea".port = config.satellite.ports.glass-server-lp-tcp;
  satellite.cloudflared.at."udp.lp.arcaea".port = config.satellite.ports.glass-server-lp-udp;

  services.glass-server = {
    enable = true;
    adminUsername = "prescientmoon";

    dataDir = "/persist/state/var/lib/arcaea/server";
    secretConfig = config.sops.templates.glass-server-config.path;

    port = config.satellite.ports.glass-server;
    linkPlayTCPPort = config.satellite.ports.glass-server-lp-tcp;
    linkPlayUDPPort = config.satellite.ports.glass-server-lp-udp;
  };
}
