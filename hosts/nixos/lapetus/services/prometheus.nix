{ config, pkgs, ... }:
{
  # {{{ Main config
  services.prometheus = {
    enable = true;
    port = config.satellite.ports.prometheus;
    webExternalUrl = config.satellite.nginx.at.prometheus.url;

    # {{{ Base exporters
    exporters = {
      # System info
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = config.satellite.ports.prometheus-node-exporter;
      };

      nginx = {
        enable = true;
        port = config.satellite.ports.prometheus-nginx-exporter;
      };
    };

    scrapeConfigs = [{
      job_name = "lapetus";
      static_configs = [{
        targets = [
          "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
          "127.0.0.1:${toString config.services.prometheus.exporters.nginx.port}"
        ];
      }];
    }];
    # }}}
  };
  # }}}
  # {{{ Networking & storage
  satellite.nginx.at.prometheus.port = config.services.prometheus.port;

  environment.persistence."/persist/state".directories = [{
    directory = "/var/lib/prometheus2";
    user = "prometheus";
    group = "prometheus";
  }];
  # }}}
}
