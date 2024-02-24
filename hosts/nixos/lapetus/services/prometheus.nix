{ config, pkgs, ... }:
let host = "prometheus.moonythm.dev";
in
{
  imports = [ ../../common/optional/services/nginx.nix ];

  # {{{ Main config
  services.prometheus = {
    enable = true;
    port = 8410;
    webExternalUrl = host;

    # {{{ Node exporter (system info)
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 8411;
      };
    };

    scrapeConfigs = [{
      job_name = "lapetus";
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
      }];
    }];
    # }}}
  };
  # }}}
  # {{{ Networking & storage
  services.nginx.virtualHosts.${host} =
    config.satellite.proxy
      config.services.prometheus.port
      { proxyWebsockets = true; };

  environment.persistence."/persist/state".directories = [{
    directory = "/var/lib/prometheus2";
    user = "prometheus";
    group = "prometheus";
  }];
  # }}}
}
