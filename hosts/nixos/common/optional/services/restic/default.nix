{ config, lib, ... }:
let
  # TODO: move the key setup to some kind of oneshot service
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
      ]
      ++ exclude;
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

      # Kept for at most 3 months
      pruneOpts = [
        "--keep-daily 3"
        "--keep-weekly 1"
        "--keep-monthly 3"
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

  services.openssh.knownHosts = {
    "restic/ed25519" = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtclizeBy1Uo3D86HpgD3LONGVH0CJ0NT+YfZlldAJd";
      hostNames = [ "zh4347.rsync.net" ];
    };

    "restic/rsa" = {
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPgHxQyaDaVxUefoUJZO/lITh0Gp0sqbP7HejQcCfZi7gAcuM6/IAuUXLHFImefCHh52x6T/cHxgL1qz26GKgdxykl06WRXlRIuE45QFSy/cd9JKr6l58fKq30ApmXRsCNwFrMlFPoEpCTqxzddZ9cLXs1Yt9dRxvFlQVEuAzw7ayvt8DE6RP9/CHYVp54wbbvUToECGwu70sxY1vFg51K+vNpvJ3J0t5j3s4c1Wls4BrIwqi2U8kqCq9Nj2CUIQqjM+93CSqEacR3qOGvG/6QMzd733wzpJ/iZee+lcyTYzA0YNMosnaF01hrv7NMwtZ6xRFLlJZtMZ7JpfySrOBr";
      hostNames = [ "zh4347.rsync.net" ];
    };

    "restic/sha2" = {
      publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLR2uz+YLn2KiQK0Luu8rhfWS6LHgUfGAWB1j8rM2MKn4KZ2/LhIX1CYkPKMTPxHr6mzayeL1T1hyJIylxXv0BY=";
      hostNames = [ "zh4347.rsync.net" ];
    };
  };
}
