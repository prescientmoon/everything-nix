{ lib, config, ... }:
{
  sops.secrets.forgejo_mail_password = {
    sopsFile = ../secrets.yaml;
    owner = config.services.forgejo.user;
    group = config.services.forgejo.group;
  };

  satellite.cloudflared.at.git.port = config.satellite.ports.forgejo;
  satellite.cloudflared.at."ssh.git" = {
    protocol = "ssh";
    port = config.satellite.ports.forgejo-ssh;
  };

  services.forgejo = {
    enable = true;
    stateDir = "/persist/state/var/lib/forgejo";
    mailerPasswordFile = config.sops.secrets.forgejo_mail_password.path;
    dump.enable = false; # We already backup via rsync + have zfs snapshots to rollback to

    lfs.enable = true;

    # See [the cheatsheet](https://docs.gitea.com/next/administration/config-cheat-sheet)
    settings = {
      default.APP_NAME = "moonforge";

      server = {
        DOMAIN = config.satellite.cloudflared.at.git.host;
        HTTP_PORT = config.satellite.cloudflared.at.git.port;
        ROOT_URL = config.satellite.cloudflared.at.git.url;
        LANDING_PAGE = "prescientmoon"; # Make my profile the landing page
        SSH_DOMAIN = config.satellite.cloudflared.at."ssh.git".host;
        SSH_PORT = config.satellite.ports.forgejo-ssh;
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
        DEFAULT_REPO_UNITS = lib.strings.concatStringsSep "," [ "repo.code" ];
      };
    };
  };

  # Clean up dumps older than a week.
  # The data is also saved in zfs snapshots and rsync backups,
  # so this is just an extra layer of safety.
  systemd.tmpfiles.rules = [ "d ${config.services.forgejo.stateDir}/dump - - - 7d" ];
}
