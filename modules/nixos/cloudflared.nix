{ config, lib, ... }:
let cfg = config.satellite.cloudflared;
in
{
  options.satellite.cloudflared = {
    tunnel = lib.mkOption {
      type = lib.types.string;
      description = "Cloudflare tunnel id to use for the `satellite.cloudflared.proxy` helper";
    };

    proxy = lib.mkOption {
      type = lib.types.functionTo lib.types.anything;
      description = "Helper function for generating a quick proxy config";
    };
  };

  config.satellite.cloudflared.proxy = from: {
    ${cfg.tunnel} = {
      ingress.${from} = "http://localhost:80";
    };
  };
}
