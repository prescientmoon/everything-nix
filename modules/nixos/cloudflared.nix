{ config, lib, ... }:
let
  cfg = config.satellite.cloudflared;
in
{
  options.satellite.cloudflared = {
    tunnel = lib.mkOption {
      type = lib.types.str;
      description = "Cloudflare tunnel id to use for the `satellite.cloudflared.at` helper";
    };

    domain = lib.mkOption {
      description = "Root domain to use as a default for configurations.";
      type = lib.types.str;
      default = config.satellite.dns.domain;
    };

    at = lib.mkOption {
      description = "List of hosts to set up ingress rules for";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options = {
              subdomain = lib.mkOption {
                description = ''
                  Subdomain to use for host generation.
                  Only required if `host` is not set manually.
                '';
                type = lib.types.str;
                default = name;
              };

              port = lib.mkOption {
                description = "Localhost port to point the tunnel at";
                type = lib.types.port;
              };

              host = lib.mkOption {
                description = "Host to direct traffic from";
                type = lib.types.str;
                default = "${config.subdomain}.${cfg.domain}";
              };

              protocol = lib.mkOption {
                description = "The protocol to redirect traffic through";
                type = lib.types.str;
                default = "http";
              };

              url = lib.mkOption {
                description = "External https url used to access this host";
                type = lib.types.str;
              };
            };

            config.url = "https://${config.host}";
          }
        )
      );
    };
  };

  config.services.cloudflared.tunnels.${cfg.tunnel}.ingress = lib.attrsets.mapAttrs' (
    _:
    {
      port,
      host,
      protocol,
      ...
    }:
    {
      name = host;
      value = "${protocol}://localhost:${toString port}";
    }
  ) cfg.at;

  config.satellite.dns.records =
    let
      mkDnsRecord =
        { subdomain, ... }:
        {
          type = "CNAME";
          at = subdomain;
          zone = cfg.domain;
          value = "${cfg.tunnel}.cfargotunnel.com.";
        };
    in
    lib.attrsets.mapAttrsToList (_: mkDnsRecord) cfg.at;
}
