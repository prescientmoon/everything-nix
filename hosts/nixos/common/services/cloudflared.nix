{ config, lib, ... }:
let
  cfg = config.satellite.cloudflared;
in
{
  # {{{ Module options
  options.satellite.cloudflared = {
    enable = lib.mkEnableOption "satellite's greetd integration";

    tunnel = lib.mkOption {
      type = lib.types.str;
      description = "Cloudflare tunnel id to use for the `satellite.cloudflared.at` helper";
    };

    domain = lib.mkOption {
      description = "Root domain to use as a default for configurations.";
      type = lib.types.str;
      default = config.satellite.dns.domain;
    };

    credentialsFile = lib.mkOption {
      description = "The file containing the credentials to use for authentication.";
      type = lib.types.path;
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
                default = if config.subdomain == "" then cfg.domain else "${config.subdomain}.${cfg.domain}";
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
  # }}}

  config = lib.mkIf cfg.enable {
    # {{{ Cloudflare config
    services.cloudflared =
      let
        mkIngressMapping =
          {
            port,
            host,
            protocol,
            ...
          }:
          {
            name = host;
            value = "${protocol}://localhost:${toString port}";
          };
      in
      {
        enable = true;
        tunnels.${cfg.tunnel} = {
          default = "http_status:404";
          ingress = lib.attrsets.mapAttrs' (_: mkIngressMapping) cfg.at;
          credentialsFile = cfg.credentialsFile;
        };
      };
    # }}}
    # {{{ DNS records
    satellite.dns.records =
      let
        mkDnsRecord =
          { subdomain, ... }:
          {
            type = if subdomain == "" then "ALIAS" else "CNAME";
            at = subdomain;
            zone = cfg.domain;
            value = "${cfg.tunnel}.cfargotunnel.com.";
            enableCloudflareProxy = true;
          };
      in
      lib.attrsets.mapAttrsToList (_: mkDnsRecord) cfg.at;
    # }}}
  };
}
