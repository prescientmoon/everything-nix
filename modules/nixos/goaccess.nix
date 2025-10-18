{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.goaccess;
  nginxCfg = config.services.nginx;
  user = cfg.user;
  types = lib.types;
in
{
  options.services.goaccess = {
    enable = lib.mkEnableOption "goaccess service";

    package = lib.mkOption {
      type = types.package;
      default = pkgs.goaccess;
      description = "The Goaccess package.";
    };

    user = lib.mkOption {
      type = types.nonEmptyStr;
      default = "goaccess";
      description = "The username to use for running the Goaccess service.";
    };

    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/${user}";
      description = "The directory in which the Goaccess data is saved.";
    };

    dataRetentionDays = lib.mkOption {
      type = types.int;
      default = 7;
      description = "The number of days for which the Goaccess server retains the report data.";
    };

    reportDir = lib.mkOption {
      type = types.path;
      default = "/var/www/${user}";
      description = "The directory in which the Goaccess report file is saved.";
    };

    host = lib.mkOption {
      type = types.nonEmptyStr;
      default = "127.0.0.1";
      description = "The host to run the Goaccess server on.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 7890;
      description = "The port to run the Goaccess server on.";
    };

    logFilePath = lib.mkOption {
      type = types.path;
      description = "The full path to the log file to analyze.";
    };

    logFileFormat = lib.mkOption {
      type = types.enum [
        "COMBINED"
        "VCOMBINED"
        "COMMON"
        "VCOMMON"
        "W3C"
        "SQUID"
        "CLOUDFRONT"
        "CLOUDSTORAGE"
        "AWSELB"
        "AWSS3"
        "AWSALB"
        "CADDY"
        "TRAEFIKCLF"
      ];
      description = "The format of the log file to analyze.";
    };

    reportTitle = lib.mkOption {
      type = types.nullOr types.nonEmptyStr;
      default = null;
      description = "The title of the report webpage.";
    };

    enableNginx = lib.mkEnableOption ''
      Nginx as the reverse proxy for the Goaccess server. If enabled, an Nginx virtual host will
      be created for access to the Goaccess server'';

    nginxEnableSSL = lib.mkEnableOption "SSL for the Nginx reverse proxy";

    serverHost = lib.mkOption {
      type = types.nonEmptyStr;
      description = "The full public domain of the Goaccess server.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${user} = {
      isSystemUser = true;
      group = user;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.${user} = { };
    users.users."${nginxCfg.user}" = lib.mkIf cfg.enableNginx {
      extraGroups = [ user ];
    };

    systemd.tmpfiles.rules = [
      # Create and clean-up directory
      "d ${cfg.reportDir}/ 750 ${user} ${user}"
      # Adjust directory permissions
      # (is this even necessary?)
      "Z ${cfg.reportDir} 750 ${user} ${user}"
    ];

    systemd.services.goaccess = {
      enable = true;
      description = "goaccess real-time dashboard service";
      restartIfChanged = true;
      restartTriggers = [ pkgs.goaccess ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        User = user;
        Group = user;
        WorkingDirectory = cfg.dataDir;
        Type = "simple";
        ExecStart = ''
          ${cfg.package}/bin/goaccess --log-file=${cfg.logFilePath} --log-format=${cfg.logFileFormat} \
            --anonymize-ip --persist --restore --db-path=${cfg.dataDir} --keep-last=${toString cfg.dataRetentionDays} \
            --all-static-files --real-time-html \
            ${if cfg.reportTitle != null then "--html-report-title=\"${cfg.reportTitle}\"" else ""} \
            --output=${cfg.reportDir}/index.html --addr=127.0.0.1 --port=${toString cfg.port} \
            --ws-url=wss://${cfg.serverHost}:443/ws --origin=https://${cfg.serverHost}'';

        AmbientCapabilities = [ ];
        CapabilityBoundingSet = [
          "~CAP_RAWIO"
          "~CAP_MKNOD"
          "~CAP_AUDIT_CONTROL"
          "~CAP_AUDIT_READ"
          "~CAP_AUDIT_WRITE"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_TIME"
          "~CAP_SYS_MODULE"
          "~CAP_SYS_PACCT"
          "~CAP_LEASE"
          "~CAP_LINUX_IMMUTABLE"
          "~CAP_IPC_LOCK"
          "~CAP_BLOCK_SUSPEND"
          "~CAP_WAKE_ALARM"
          "~CAP_SYS_TTY_CONFIG"
          "~CAP_MAC_ADMIN"
          "~CAP_MAC_OVERRIDE"
          "~CAP_NET_ADMIN"
          "~CAP_NET_BROADCAST"
          "~CAP_NET_RAW"
          "~CAP_SYS_ADMIN"
          "~CAP_SYS_PTRACE"
          "~CAP_SYSLOG"
        ];
        DevicePolicy = "closed";
        KeyringMode = "private";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
    };

    services.nginx = lib.mkIf cfg.enableNginx {
      enable = true;
      virtualHosts."${cfg.serverHost}" = {
        # Hard-coded ACME config
        enableACME = true;
        acmeRoot = null;
        forceSSL = true;

        locations = {
          "/" = {
            alias = "${cfg.reportDir}/";
            extraConfig = ''
              add_header Cache-Control 'private no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
              if_modified_since off;
              expires off;
              etag off;
            '';
          };
          "/ws" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
