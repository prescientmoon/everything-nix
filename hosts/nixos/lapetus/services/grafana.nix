{ config, pkgs, ... }:
let
  secret = name: "$__file{${config.sops.secrets.${name}.path}}";
  sopsSettings = {
    sopsFile = ../secrets.yaml;
    owner = "grafana";
  };
in
{
  imports = [
    ../../common/optional/services/nginx.nix
    ./prometheus.nix
  ];

  sops.secrets.grafana_smtp_pass = sopsSettings;
  sops.secrets.grafana_discord_webhook = sopsSettings;

  # {{{ Main config
  services.grafana = {
    enable = true;

    settings = {
      server.domain = "grafana.moonythm.dev";
      server.http_port = 8409;

      # {{{ Smtp
      smtp = rec {
        enabled = true;

        user = "grafana@orbit.moonythm.dev";
        from_name = "Grafana";
        from_address = user;

        host = "smtp.migadu.com:465";
        password = secret "grafana_smtp_pass";
        startTLS_policy = "NoStartTLS";
      };
      # }}}
    };

    # {{{ Provisoning
    provision = {
      enable = true;

      # https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/file-provisioning/
      alerting.contactPoints.settings.contactPoints = [{
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
