{
  config,
  lib,
  pkgs,
  ...
}:
let
  defaultUser = "taritsu";
  cfg = config.services.glass-server;
  pkg = pkgs.glassServer;

  databaseRepo = pkgs.fetchFromGitHub {
    owner = "IoIiro";
    repo = "arcaea_database";
    rev = "e131978a3aff706c53d5227ee27c23e8011fbb4e";
    sha256 = "1a0gqsvajpws85ajd8qxsfskr7fkfl9b290x0v6pqxjh2ylfy6gf";
  };

  glassServerConfig = {
    # {{{ Public config
    HOST = "0.0.0.0";
    PORT = cfg.port;
    GAME_API_PREFIX = "/join/21";
    USERNAME = cfg.adminUsername;

    LOG_BASE_DIR = "${cfg.dataDir}/log";
    WORLD_MAP_FOLDER_PATH = "${cfg.dataDir}/map/";
    SONG_FILE_FOLDER_PATH = "${cfg.dataDir}/songs/";
    SONGLIST_FILE_PATH = "${cfg.dataDir}/songs/songlist";
    CONTENT_BUNDLE_FOLDER_PATH = "${cfg.dataDir}/bundle/";
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

    WORLD_RANK_MAX = 200;
    IS_APRILFOOLS = true;
    UPDATE_WITH_NEW_CHARACTER_DATA = true;
    CHARACTER_FULL_UNLOCK = true;
    WORLD_SONG_FULL_UNLOCK = true;
    WORLD_SCENERY_FULL_UNLOCK = true;
    SAVE_FULL_UNLOCK = true;
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

    secretConfig = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to additional config that might be generated at runtime by a tool
        like sops. This might be useful for things like the admin password
      '';
    };
  };
  # }}}

  config = {
    # {{{ Create directory structure
    systemd.tmpfiles.rules = [
      "f ${cfg.dataDir}/config.json 0700 ${cfg.user} ${cfg.user}"
      "d ${cfg.dataDir}/log         0700 ${cfg.user} ${cfg.user}"
      "d ${cfg.dataDir}/map         0700 ${cfg.user} ${cfg.user}"
      "d ${cfg.dataDir}/songs       0700 ${cfg.user} ${cfg.user}"
      "d ${cfg.dataDir}/bundle      0700 ${cfg.user} ${cfg.user}"
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
          # Merge the given configs
          ${lib.getExe pkgs.jq} -s ".[0] * .[1]" \
            ${cfg.secretConfig} \
            ${serverConfigPath} \
            > ${configPath}

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
  };
}
