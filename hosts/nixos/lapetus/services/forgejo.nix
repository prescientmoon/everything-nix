{ lib, config, ... }:
{
  sops.secrets.forgejo_mail_password = {
    sopsFile = ../secrets.yaml;
    owner = config.services.forgejo.user;
    group = config.services.forgejo.group;
  };

  satellite.cloudflared.at.git.port = config.satellite.ports.forgejo;

  # Add CNAME record for ssh access. Unlike the http interface,
  # this will only get exposed over tailscale, so it is safe.
  satellite.dns.records = [
    {
      type = "CNAME";
      zone = config.satellite.dns.domain;
      at = "ssh.git";
      to = config.networking.hostName;
    }
  ];

  services.forgejo = {
    enable = true;
    stateDir = "/persist/state/var/lib/forgejo";
    secrets.mailer.PASSWD = config.sops.secrets.forgejo_mail_password.path;
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
        SSH_DOMAIN = "ssh.${config.satellite.cloudflared.at.git.host}";
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
        DEFAULT_REPO_UNITS = lib.concatStringsSep "," [ "repo.code" ];
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
      };
    };
  };

  # Clean up dumps older than a week.
  # The data is also saved in zfs snapshots and rsync backups,
  # so this is just an extra layer of safety.
  systemd.tmpfiles.rules = [ "d ${config.services.forgejo.stateDir}/dump - - - 7d" ];
}
