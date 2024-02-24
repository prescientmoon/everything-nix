{ config, pkgs, ... }:
let secret = name: "$__file{${config.sops.secrets.${name}.path}}";
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
      smtp = rec {
        enabled = true;
        host = "smtp.migadu.com:465";
        from_name = "Grafana";
        password = secret "grafana_smtp_pass";
        user = "grafana@orbit.moonythm.dev";
        from_address = user;
        skip_verify = true;
        startTLS_policy = "NoStartTLS";
      };
      # }}}
    };

    # {{{ Provisoning
    provision = {
      enable = true;

      # https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/file-provisioning/
      alerting.contactPoints.settings = {
        deleteContactPoints = [
          { uid = "main_discord"; }
          { uid = "main_email"; }
        ];

        contactPoints = [{
          name = "main";
          receivers = [
            {
              uid = "main_discord";
              type = "discord";
              settings.url = secret "grafana_discord_webhook";
            }
            {
              uid = "main_email";
              type = "email";
              settings.addresses = "colimit@moonythm.dev";
            }
          ];
        }];
      };

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

  environment.persistence."/persist/state".directories = [{
    directory = config.services.grafana.dataDir;
    user = "grafana";
    group = "grafana";
  }];
  # }}}
}
