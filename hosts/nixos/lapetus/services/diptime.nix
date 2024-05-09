# I couldn't find a hosted version of this
{ pkgs, config, ... }: {
  imports = [ ../../common/optional/services/nginx.nix ];

  services.nginx.virtualHosts."diptime.moonythm.dev" =
    config.satellite.static (pkgs.fetchFromGitHub {
      owner = "bhickey";
      repo = "diplomatic-timekeeper";
      rev = "d6ea7b9d9e94ee6d2db8e4e7cff5f8f1c3f04464";
      sha256 = "09s6awz5m6hzpc6jp96c118i372430c7b41acm5m62bllcvrj9vk";
    });

  sops.secrets.cloudflare_tunnel_credentials = {
    sopsFile = ../secrets.yaml;
    owner = config.services.cloudflared.user;
    group = config.services.cloudflared.group;
  };

  services.cloudflared = {
    enable = true;
    tunnels."347d9ead-a523-4f8b-bca7-3066e31e2952" = {
      credentialsFile = config.sops.secrets.cloudflare_tunnel_credentials.path;
      default = "http_status:404";
      ingress."diptime.moonythm.dev" = "http://localhost:8416";
    };
  };
}
