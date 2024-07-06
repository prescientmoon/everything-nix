{ lib, config, ... }:
let
  port = config.satellite.ports.forgejo;
  host = "git.moonythm.dev";
  cfg = config.services.forgejo;
in
{
  sops.secrets.forgejo_mail_password = {
    sopsFile = ../secrets.yaml;
    owner = cfg.user;
    group = cfg.group;
  };

  satellite.cloudflared.at.${host}.port = port;

  services.forgejo = {
    enable = true;
    stateDir = "/persist/state/var/lib/forgejo";
    mailerPasswordFile = config.sops.secrets.forgejo_mail_password.path;

    dump = {
      enable = true;
      type = "tar.gz";
    };

    lfs.enable = true;

    # See [the cheatsheet](https://docs.gitea.com/next/administration/config-cheat-sheet)
    settings = {
      default.APP_NAME = "moonforge";

      server = {
        DOMAIN = host;
        HTTP_PORT = port;
        ROOT_URL = "https://${host}";
        LANDING_PAGE = "prescientmoon"; # Make my profile the landing page
      };

      cron.ENABLED = true;
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;

      mailer = {
        ENABLED = true;
        SMTP_PORT = 465;
        SMTP_ADDR = "smtp.migadu.com";
        USER = "git@orbit.moonythm.dev";
      };

      repository = {
        DISABLE_STARS = true;
        DISABLED_REPO_UNITS = "";
        DEFAULT_REPO_UNITS = lib.strings.concatStringsSep "," [
          "repo.code"
        ];
      };
    };
  };
}
