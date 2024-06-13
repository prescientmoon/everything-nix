{ config, ... }:
{
  satellite.nginx.at.warden.port = config.satellite.ports.vaultwarden;

  # {{{ Secrets 
  sops.secrets.vaultwarden_env = {
    sopsFile = ../secrets.yaml;
    owner = config.users.users.vaultwarden.name;
    group = config.users.users.vaultwarden.group;
  };
  # }}}
  # {{{ General config
  services.vaultwarden = {
    enable = true;
    environmentFile = config.sops.secrets.vaultwarden_env.path;
    config = {
      DOMAIN = "https://${config.satellite.nginx.at.warden.host}";
      ROCKET_PORT = config.satellite.nginx.at.warden.port;
      ROCKET_ADDRESS = "127.0.0.1";

      SIGNUPS_ALLOWED = false;
      SHOW_PASSWORD_HINT = false;

      SMTP_SECURITY = "force_tls";
      SMTP_PORT = 465;
      SMTP_HOST = "smtp.migadu.com";
      SMTP_FROM = "vaultwarden@orbit.moonythm.dev";
      SMTP_USERNAME = "vaultwarden@orbit.moonythm.dev";
    };
  };
  # }}}
  # {{{ Storage 
  environment.persistence."/persist/state".directories = [{
    directory = "/var/lib/bitwarden_rs";
    mode = "u=rwx,g=,o=";
    user = config.users.users.vaultwarden.name;
    group = config.users.users.vaultwarden.group;
  }];
  # }}}
}
