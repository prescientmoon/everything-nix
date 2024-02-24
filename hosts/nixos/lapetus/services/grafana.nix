{ config, pkgs, ... }:
let secret = name: "$__file(${config.sops.secrets.${name}.path})";
in
{
  imports = [
    ../../common/optional/services/nginx.nix
    ./prometheus.nix
  ];

  sops.secrets.grafana_smtp_pass.sopsFile = ../secrets.yaml;
  sops.secrets.grafana_discord_webhook.sopsFile = ../secrets.yaml;

  # {{{ Main config
  services.grafana = {
    enable = true;

    settings = {
      server.domain = "grafana.moonythm.dev";
      server.http_port = 8409;

      # {{{ Smtp
      smtp = {
        enabled = true;
        host = "smtp.migadu.com";
        port = 465;
        from_name = "Grafana";
        from_address = "grafana@orbit.moonythm.dev";
        password = secret "grafana_smtp_pass";
      };
      # }}}
    };

    # {{{ Provisoning
    provision = {
      enable = true;
      notifiers = [
        {
          uid = "email";
          name = "email";
          type = "email";
        }
        {
          uid = "discord";
          name = "discord";
          type = "discord";
          settings.webhook_url = secret "grafana_discord_webhook";
        }
      ];

      datasources.settings.datasources = [{
        name = "Prometheus";
        type = "prometheus";
        access = "proxy";
        url = "prometheus.moonythm.dev";
      }];
    };
    # }}}
  };
  # }}}
  # {{{ Networking & storage
  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} =
    config.satellite.proxy config.services.grafana.settings.server.http_port { };

  environment.persistence."/persist/state".directories = [
    config.services.grafana.dataDir
  ];
  # }}}
}
