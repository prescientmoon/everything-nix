{
  lib,
  config,
  pkgs,
  ...
}:
{
  sops.secrets.forgejo_mail_password = {
    sopsFile = ../secrets.yaml;
    owner = config.services.forgejo.user;
    group = config.services.forgejo.group;
  };

  satellite.cloudflared.at.git.port = config.satellite.ports.forgejo;

  # Protect the service from crawlers via Anubis.
  # satellite.cloudflared.at.git.port = config.satellite.ports.forgejo-anubis;
  # services.anubis.instances.forgejo = {
  #   enable = true;
  #   settings = {
  #     TARGET = "http://localhost:${toString config.satellite.ports.forgejo}";
  #     BIND = ":${toString config.satellite.ports.forgejo-anubis}";
  #     BIND_NETWORK = "tcp";
  #     COOKIE_DOMAIN = "moonythm.dev";
  #     OG_PASSTHROUGH = true;
  #     SERVE_ROBOTS_TXT = true;
  #     WEBMASTER_EMAIL = "hi@moonythm.dev";
  #   };
  # };

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
    package = pkgs.forgejo; # Defaults to LTS
    stateDir = "/persist/state/var/lib/forgejo";
    secrets.mailer.PASSWD = config.sops.secrets.forgejo_mail_password.path;
    lfs.enable = true;

    # We already backup via rsync & we have ZFS snapshots to rollback to
    dump.enable = false;

    # See the cheat-sheet:
    # https://docs.gitea.com/next/administration/config-cheat-sheet
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

        # These take up way too much space. They are also part of ZFS snapshots,
        # which only makes things worse...
        DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
      };

      ui = {
        # I do not care about ambiguous Unicode
        AMBIGUOUS_UNICODE_DETECTION = false;
      };
    };
  };

  # Clean up dumps older than a week.
  # The data is also saved in zfs snapshots and rsync backups,
  # so this is just an extra layer of safety.
  systemd.tmpfiles.rules = [ "d ${config.services.forgejo.stateDir}/dump - - - 7d" ];
}
