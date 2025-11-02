{ config, lib, ... }:
let
  cfg = config.satellite.nginx;

  mkNginxConfig = subcfg: {
    name = subcfg.host;
    value =
      let
        extra =
          if subcfg.port != null then
            {
              locations."/" = {
                proxyPass = "http://localhost:${toString subcfg.port}";
                proxyWebsockets = true;
              };
            }
          else
            {
              root = subcfg.files;
              locations."/" = {
                tryFiles = "$uri $uri/ =404";
                index = "index.html";
              };
            };
      in
      {
        enableACME = true;
        acmeRoot = null;
        forceSSL = true;
      }
      // extra;
  };

  # We automatically generate CNAME records for the configured services!
  mkDnsRecord =
    { subdomain, ... }:
    {
      type = "CNAME";
      zone = cfg.domain;
      at = subdomain;
      to = config.networking.hostName;
    };
in
{
  options.satellite.nginx = {
    enable = lib.mkEnableOption "satellite's nginx integration" // {
      default = true;
    };

    domain = lib.mkOption {
      description = "Root domain to use as a default for configurations.";
      type = lib.types.str;
      default = config.satellite.dns.domain;
    };

    at = lib.mkOption {
      description = "Per-subdomain nginx configuration";
      default = { };

      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options.location = lib.mkOption {
              default = "";
              type = lib.types.str;
              description = "Subpath to proxy to";
            };

            options.subdomain = lib.mkOption {
              description = ''
                Subdomain to use for host generation.
                Only required if `host` is not set manually.
              '';
              type = lib.types.str;
              default = name;
            };

            config.host = "${config.subdomain}.${cfg.domain}";
            options.host = lib.mkOption {
              description = "Host to route requests from";
              type = lib.types.str;
            };

            config.url = "https://${config.host}";
            options.url = lib.mkOption {
              description = "External https url used to access this host";
              type = lib.types.str;
            };

            options.port = lib.mkOption {
              description = "Port to proxy requests to";
              type = lib.types.nullOr lib.types.port;
              default = null;
            };

            options.files = lib.mkOption {
              description = "Path to serve files from";
              type = lib.types.nullOr lib.types.path;
              default = null;
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.mapAttrsToList (_: config: {
      assertion = (config.port == null) == (config.files != null);
      message = ''
        Precisely one of the options 
          'satellite.nginx.at.${config.subdomain}.port'
        and 
          'satellite.nginx.at.${config.subdomain}.files'
        must be specified.
      '';
    }) cfg.at;

    satellite.acme.enable = true;
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      statusPage = true; # Necessary for the Prometheus exporter
      virtualHosts = lib.attrsets.mapAttrs' (_: mkNginxConfig) cfg.at;
    };

    satellite.dns.records = lib.attrsets.mapAttrsToList (_: mkDnsRecord) cfg.at;
  };
}
