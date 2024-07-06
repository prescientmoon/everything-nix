{ config, lib, ... }:
let cfg = config.satellite.cloudflared;
in
{
  options.satellite.cloudflared = {
    tunnel = lib.mkOption {
      type = lib.types.str;
      description = "Cloudflare tunnel id to use for the `satellite.cloudflared.at` helper";
    };

    at = lib.mkOption {
      description = "List of hosts to set up ingress rules for";
      default = { };
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          port = lib.mkOption {
            type = lib.types.port;
            description = "Localhost port to point the tunnel at";
          };

          host = lib.mkOption {
            default = name;
            type = lib.types.str;
            description = "Host to direct traffic from";
          };
        };
      }));
    };
  };

  config.services.cloudflared.tunnels.${cfg.tunnel}.ingress = lib.attrsets.mapAttrs'
    (_: { port, host }: {
      name = host;
      value = "http://localhost:${toString port}";
    })
    cfg.at;
}
