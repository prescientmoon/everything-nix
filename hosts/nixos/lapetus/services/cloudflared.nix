{ config, ... }:
{
  sops.secrets.cloudflare_tunnel_credentials.sopsFile = ../secrets.yaml;
  satellite.cloudflared.tunnel = "347d9ead-a523-4f8b-bca7-3066e31e2952";
  services.cloudflared = {
    enable = true;
    tunnels.${config.satellite.cloudflared.tunnel} = {
      credentialsFile = config.sops.secrets.cloudflare_tunnel_credentials.path;
      default = "http_status:404";
    };
  };
}
