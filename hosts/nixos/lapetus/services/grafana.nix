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
      domain = "grafana.moonythm.dev";
      port = 8409;
      addr = "127.0.0.1";

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
      notifiers = {
        email.type = "email";

        discord = {
          type = "discord";
          settings.webhook_url = secret "grafana_discord_webhook";
        };
      };

      datasources.settings.datasources.prometheus = {
        name = "Prometheus";
        type = "prometheus";
        access = "proxy";
        url = "prometheus.moonythm.dev";
      };
    };
    # }}}
  };
  # }}}
  # {{{ Networking & storage
  services.nginx.virtualHosts.${config.services.grafana.domain} =
    config.satellite.proxy config.services.grafana.port { };

  environment.persistence."/persist/state".directories = [
    config.services.grafana.dataDir
  ];
  # }}}
}
