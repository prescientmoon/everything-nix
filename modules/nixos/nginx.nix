{ config, lib, ... }:
let cfg = config.satellite.nginx;
in
{
  options.satellite.nginx = {
    domain = lib.mkOption {
      description = "Root domain to use as a default for configurations.";
      type = lib.types.str;
    };

    at = lib.mkOption {
      description = "Per-subdomain nginx configuration";
      type = lib.types.attrsOf (lib.types.submodule ({ name, config, ... }: {
        options.name = lib.mkOption {
          description = "Attribute name leading to this submodule";
          type = lib.types.str;
        };

        config.name = name;

        options.host = lib.mkOption {
          description = "Host to route requests from";
          type = lib.types.str;
          default = "${name}.${cfg.domain}";
        };

        options.url = lib.mkOption {
          description = "External https url used to access this host";
          type = lib.types.str;
        };

        config.url = "https://${config.host}";

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
      }));
      default = { };
    };
  };

  config = {
    assertions =
      let assertSingleTarget = config:
        {
          assertion = (config.port == null) == (config.files != null);
          message = ''
            Precisely one of the options 'satellite.nginx.at.${config.name}.port'
            and 'satellite.nginx.at.${config.name}.files' must be specified.
          '';
        };
      in lib.mapAttrsToList (_: assertSingleTarget) cfg.at;

    services.nginx.virtualHosts =
      let mkNginxConfig = { host, port, files, ... }: {
        name = host;
        value =
          let extra =
            if port != null then {
              locations."/" = {
                proxyPass = "http://localhost:${toString port}";
                proxyWebsockets = true;
              };
            }
            else {
              root = files;
            };
          in
          {
            enableACME = true;
            acmeRoot = null;
            forceSSL = true;
          } // extra;
      };
      in lib.attrsets.mapAttrs' (_: mkNginxConfig) cfg.at;
  };
}
