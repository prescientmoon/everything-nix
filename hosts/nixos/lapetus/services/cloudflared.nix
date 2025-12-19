{ config, ... }:
{
  sops.secrets.cloudflare_tunnel_credentials.sopsFile = ../secrets.yaml;

  satellite.cloudflared = {
    enable = true;
    tunnel = "347d9ead-a523-4f8b-bca7-3066e31e2952";
    credentialsFile = config.sops.secrets.cloudflare_tunnel_credentials.path;
  };
}
