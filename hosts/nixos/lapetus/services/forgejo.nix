{ lib, config, ... }:
let
  port = 8419;
  host = "git.moonythm.dev";
  cfg = config.services.forgejo;
in
{
  sops.secrets.forgejo_mail_password = {
    sopsFile = ../secrets.yaml;
    owner = cfg.user;
    group = cfg.group;
  };

  satellite.cloudflared.targets.${host}.port = port;

  services.forgejo = {
    enable = true;
    appName = "moonforge";
    stateDir = "/persist/state/var/lib/forgejo";
    mailerPasswordFile = config.sops.secrets.forgejo_mail_password.path;

    dump = {
      enable = true;
      type = "tar.gz";
    };

    lfs.enable = true;

    # See [the cheatsheet](https://docs.gitea.com/next/administration/config-cheat-sheet)
    settings = {
      session.COOKIE_SECURE = true;
      server = {
        DOMAIN = host;
        HTTP_PORT = port;
        ROOT_URL = "https://${host}";
        LANDING_PAGE = "prescientmoon"; # Make my profile the landing page
      };

      cron.ENABLED = true;
      # service.DISABLE_REGISTRATION = true;

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
