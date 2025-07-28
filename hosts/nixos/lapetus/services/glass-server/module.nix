{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  defaultUser = "tairitsu";
  cfg = config.services.glass-server;
  pkg = pkgs.glassServer;

  databaseRepo = pkgs.fetchFromGitHub {
    owner = "IoIiro";
    repo = "arcaea_database";
    rev = "e131978a3aff706c53d5227ee27c23e8011fbb4e";
    sha256 = "1a0gqsvajpws85ajd8qxsfskr7fkfl9b290x0v6pqxjh2ylfy6gf";
  };

  triplet = a: b: c: [
    a
    b
    c
  ];

  glassServerConfig = {
    # {{{ Public config
    HOST = "0.0.0.0";
    PORT = cfg.port;
    GAME_API_PREFIX = "/join/21";
    USERNAME = cfg.adminUsername;

    LOG_FOLDER_PATH = "${cfg.dataDir}/log";
    WORLD_MAP_LEPHON_NELL_FOLDER_PATH = "${pkg}/source/database/map_lephon_nell";
    SQLITE_DATABASE_BACKUP_FOLDER_PATH = "${cfg.dataDir}/backup/";

    DATABASE_INIT_PATH = "${pkg}/source/database/init/";
    SQLITE_DATABASE_PATH = "${cfg.dataDir}/database/arcaea_database.db";
    SQLITE_LOG_DATABASE_PATH = "${cfg.dataDir}/database/arcaea_log.db";
    SQLITE_DATABASE_DELETED_PATH = "${cfg.dataDir}/database/arcaea_database_deleted.db";

    SET_LINKPLAY_SERVER_AS_SUB_PROCESS = true;
    LINKPLAY_HOST = "0.0.0.0";
    LINKPLAY_TCP_PORT = cfg.linkPlayTCPPort;
    LINKPLAY_UDP_PORT = cfg.linkPlayUDPPort;
    LINKPLAY_DISPLAY_HOST = config.networking.hostName;

    LOGIN_DEVICE_NUMBER_LIMIT = 3;
    ALLOW_LOGIN_SAME_DEVICE = true;
    ALLOW_BAN_MULTIDEVICE_USER_AUTO = false;
    SONG_FILE_HASH_PRE_CALCULATE = false;
    SONG_HASH_CHECKS = false;

    DEFAULT_MEMORIES = 3141592;
    WORLD_RANK_MAX = 5;
    UPDATE_WITH_NEW_CHARACTER_DATA = true;
    IS_APRILFOOLS = false;
    CHARACTER_FULL_UNLOCK = false;
    WORLD_SONG_FULL_UNLOCK = false;
    WORLD_SCENERY_FULL_UNLOCK = false;
    SAVE_FULL_UNLOCK = false;
    STAMINA_RECOVER_TICK = 1; # Recover stamina instantly
    SKILL_FATALIS_WORLD_LOCKED_TIME = 1; # Recover from Fatalis instantly
    STEALTH_MODE_MAX_MEMS = 500;
    PTT_FORMULA = [
      (triplet "best" 30 (1.0 / 40))
      (triplet "best" 10 (1.0 / 40))
    ];

    CONTENT_BUNDLE_FOLDER_PATH = "${pkgs.shimmeringextra}/bundles";
    SONGLIST_FILE_PATH = "${pkgs.shimmering-private-config}/songlist.json";
    SONG_FILE_FOLDER_PATH = "${pkgs.glass-charts}";
    WORLD_MAP_FOLDER_PATH = "${pkgs.glass-maps}/maps";
    # }}}
  };

  serverConfigPath = pkgs.writeTextFile {
    name = "glass-server-public-config";
    text = builtins.toJSON glassServerConfig;
  };

  configPath = "${cfg.dataDir}/config.json";
in
{
  # {{{ Options
  options.services.glass-server = {
    enable = lib.mkEnableOption "Arcaea private server";

    dataDir = lib.mkOption { type = lib.types.str; };
    port = lib.mkOption { type = lib.types.port; };
    linkPlayTCPPort = lib.mkOption { type = lib.types.port; };
    linkPlayUDPPort = lib.mkOption { type = lib.types.port; };
    adminUsername = lib.mkOption { type = lib.types.str; };

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = ''
        User account under which the server runs. If not specified, a default
        user will be created.
      '';
    };

    secretKeyFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to a file containing the secret key to use for the server";
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to a file containing the admin password for the server";
    };

    apiTokenFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to a file containing the api token for the server";
    };

  };
  # }}}

  config = {
    # {{{ Create directory structure
    systemd.tmpfiles.rules = [
      "f ${cfg.dataDir}/config.json 0700 ${cfg.user} ${cfg.user}"
      "d ${cfg.dataDir}/log         0700 ${cfg.user} ${cfg.user}"
      "d ${cfg.dataDir}/backup      0700 ${cfg.user} ${cfg.user}"
      "d ${cfg.dataDir}/database    0700 ${cfg.user} ${cfg.user}"

      "L+ ${cfg.dataDir}/pkgs/server 0755 ${cfg.user} ${cfg.user} - ${pkg}"
      "L+ ${cfg.dataDir}/pkgs/db     0755 ${cfg.user} ${cfg.user} - ${databaseRepo}"
    ];
    # }}}
    # {{{ Systemd service
    systemd.services.arcaea-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Arcaea private server";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.user;
        ExecStart = pkgs.writeShellScript "glass-server-startup" ''
          # Copy secrets into config
          ${lib.getExe pkgs.jq} "\
              .SECRET_KEY=\"$(cat ${cfg.secretKeyFile})\" |\
              .PASSWORD=\"$(cat ${cfg.passwordFile})\" |\
              .API_TOKEN=\"$(cat ${cfg.apiTokenFile})\" \
            " \
            ${serverConfigPath} \
            > ${configPath}

          # TODO: only do this if the db file already exists...
          # Update the db
          ${lib.getExe pkgs.glass-server-db-updater} \
            ${glassServerConfig.SQLITE_DATABASE_PATH}

          # Start the server
          ARCAEA_JSON_CONFIG_PATH=${configPath} ${pkg}/bin/glass-server
        '';

        Restart = "on-failure";
      };
    };
    # }}}
    # {{{ Create default user
    users = lib.optionalAttrs (cfg.user == defaultUser) {
      users.${defaultUser} = {
        group = defaultUser;
        isSystemUser = true;
      };

      groups.${defaultUser} = { };
    };
    # }}}

    services.sqliteWeb.enable = true;
    services.sqliteWeb.databases.glass = {
      user = cfg.user;
      port = config.satellite.ports.sqlite-web-glass;
      file = glassServerConfig.SQLITE_DATABASE_PATH;
      passwordFile = cfg.passwordFile;
    };
  };
}
