{ config, ... }:
let
  port = 8404;
  host = "warden.moonythm.dev";
in
{
  sops.secrets.vaultwarden_env.sopsFile = ../secrets.yaml;

  services.vaultwarden = {
    enable = true;
    environmentFile = config.sops.secrets.vaultwarden_env.path;
    config = {
      DOMAIN = "https://${host}";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = port;
      DATA_FOLDER = "/persist/state/var/lib/vaultwarden";

      SIGNUPS_ALLOWED = true;
      SHOW_PASSWORD_HINT = false;

      SMTP_SECURITY = "force_tls";
      SMTP_PORT = 465;
      SMTP_HOST = "smtp.migadu.com";
      SMTP_FROM = "vaultwarden@orbit.moonythm.dev";
      SMTP_USERNAME = "vaultwarden";
    };
  };

  services.nginx.virtualHosts.${host} =
    config.satellite.proxy port { proxyWebsockets = true; };
}
