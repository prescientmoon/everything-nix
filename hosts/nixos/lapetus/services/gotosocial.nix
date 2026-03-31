{ config, ... }:
let
  serverName = config.satellite.dns.domain;
in
{
  satellite.nginx.at.social = {
    port = config.satellite.ports.gotosocial;
    scope = "public";
  };

  services.gotosocial = {
    enable = true;

    environmentFile = config.sops.templates."gotosocial.env".path;
    settings = {
      port = config.satellite.ports.gotosocial;
      host = config.satellite.nginx.at.social.host;
      account-domain = serverName;
      landing-page-user = "prescientmoon";

      instance-expose-custom-emojis = true;
      accounts-allow-custom-css = true;
      accounts-max-profile-fields = 12;

      cache.memory-target = "50MiB";
      metrics-enabled = true;

      smtp-host = "smtp.migadu.com";
      smtp-port = 465;
      smtp-username = "gotosocial@orbit.moonythm.dev";
      smtp-from = "gotosocial@orbit.moonythm.dev";
      smtp-disclose-recipients = true;
    };
  };

  # Secrets
  sops = {
    secrets.gotosocial_email_pass = {
      sopsFile = ../secrets.yaml;
      owner = "gotosocial";
      group = "gotosocial";
    };

    templates."gotosocial.env".content = ''
      GTS_SMTP_PASSWORD=${config.sops.placeholder.gotosocial_email_pass}
    '';
  };

  # Redirects for the split domain setup
  services.nginx.virtualHosts.${serverName}.extraConfig =
    let
      url = config.satellite.nginx.at.social.url;
    in
    ''
      location /.well-known/webfinger {
        rewrite ^.*$ ${url}/.well-known/webfinger permanent;
      }

      location /.well-known/host-meta {
        rewrite ^.*$ ${url}/.well-known/host-meta permanent;
      }

      location /.well-known/nodeinfo {
        rewrite ^.*$ ${url}/.well-known/nodeinfo permanent;
      }
    '';

  # Persistence
  environment.persistence."/persist/state".directories = [
    {
      directory = "/var/lib/gotosocial";
      user = "gotosocial";
      group = "gotosocial";
    }
  ];

  # Prometheus metrics
  systemd.services.gotosocial.environment = {
    OTEL_METRICS_PRODUCERS = "prometheus";
    OTEL_METRICS_EXPORTER = "prometheus";
    OTEL_EXPORTER_PROMETHEUS_HOST = "127.0.0.1";
    OTEL_EXPORTER_PROMETHEUS_PORT = toString config.satellite.ports.prometheus-gotosocial-exporter;
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "gotosocial";
      static_configs = [
        {
          targets = [
            "127.0.0.1:${toString config.satellite.ports.prometheus-gotosocial-exporter}"
          ];
        }
      ];
    }
  ];
}
