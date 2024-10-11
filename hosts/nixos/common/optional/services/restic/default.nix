{ config, lib, ... }:
let
  backupUrl = lib.removeSuffix "\n" (builtins.readFile ./url.txt);

  # {{{ Backup helper
  createBackup =
    {
      name,
      paths,
      exclude,
      pruneOpts,
    }:
    {
      inherit pruneOpts paths;

      initialize = true;
      repository = "sftp:${backupUrl}:backups/${name}";
      passwordFile = config.sops.secrets.backup_password.path;
      extraOptions = [ "sftp.args='-i /persist/state/etc/ssh/ssh_host_ed25519_key'" ];

      exclude = [
        ".direnv" # Direnv
        ".git" # Git
        ".stfolder" # Syncthing
        ".stversions" # Syncthing
        ".snapshots" # Snapper
      ] ++ exclude;
    };
in
# }}}
{
  sops.secrets.backup_password.sopsFile = ../../../secrets.yaml;

  services.restic.backups = {
    # {{{ Data
    data = createBackup {
      name = "data";

      # Kept for at most 1 year
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
        "--keep-yearly 0"
      ];

      paths = [ "/persist/data" ];
      exclude = [
        # Projects are available on github and in my own forge already
        "/persist/data${config.users.users.pilot.home}/projects"

        # Screenshots are usually worthless
        "/persist/data${config.users.users.pilot.home}/media/pictures/screenshots"
      ];
    };
    # }}}
    # {{{ State
    state = createBackup {
      name = "state";

      # Kept for at most 1 month
      pruneOpts = [
        "--keep-daily 3"
        "--keep-weekly 1"
        "--keep-monthly 1"
        "--keep-yearly 0"
      ];

      paths = [ "/persist/state" ];
      exclude =
        let
          home = "/persist/state${config.users.users.pilot.home}";
        in
        [
          "/persist/state/var/log"
          "${home}/discord"
          "${home}/element"
          "${home}/firefox"
          "${home}/lutris"
          "${home}/qmk"
          "${home}/signal"
          "${home}/spotify"
          "${home}/steam"
          "${home}/whatsapp"
          "${home}/wine"
        ];
    };
    # }}}
  };

  environment.persistence."/persist/local/cache".directories = [
    "/var/cache/restic-backups-data"
    "/var/cache/restic-backups-state"
  ];
}
