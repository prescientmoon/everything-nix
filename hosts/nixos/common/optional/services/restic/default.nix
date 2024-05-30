{ config, lib, ... }:
let
  backupUrl = lib.removeSuffix "\n" (builtins.readFile ./url.txt);

  # {{{ Backup helper
  createBackup = { name, paths, exclude, pruneOpts }: {
    inherit pruneOpts paths;

    initialize = true;
    repository = "sftp:${backupUrl}:backups/${config.networking.hostName}/${name}";
    passwordFile = config.sops.secrets.backup_password.path;
    extraOptions = [ "sftp.args='-i ${config.users.users.pilot.home}/.ssh/id_ed25519'" ];

    exclude = [
      # Syncthing / direnv / git stuff
      ".direnv"
      ".git"
      ".stfolder"
      ".stversions"
    ] ++ exclude;
  };
  # }}}
in
{
  sops.secrets.backup_password.sopsFile = ../../../secrets.yaml;

  services.restic.backups = {
    # {{{ Data
    data = createBackup {
      name = "data";
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
      ];
    };
    # }}}
    # {{{ State
    state = createBackup {
      name = "state";
      pruneOpts = [
        "--keep-daily 3"
        "--keep-weekly 1"
        "--keep-monthly 1"
        "--keep-yearly 0"
      ];

      paths = [ "/persist/state" ];
      exclude =
        let home = "/persist/state/${config.users.users.pilot.home}";
        in
        [
          "${home}/discord" # There's lots of cache stored in here
          "${home}/steam" # Games can be quite big
        ];
    };
    # }}}
  };
}

