{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.sqliteWeb;
in
{
  meta.maintainers = with lib.maintainers; [ ];

  options.services.sqliteWeb = {
    enable = lib.mkEnableOption "sqlite-web, a Web-based SQLite database browser written in Python";

    package = lib.mkOption {
      description = "sqlite-web package to use";
      type = lib.types.package;
      example = lib.literalExpression "pkgs.sqlite-web";
      default = pkgs.sqlite-web;
      defaultText = "pkgs.sqlite-web";
    };

    databases = lib.mkOption {
      description = "Configuration for multiple instances of sqlite-web";

      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            port = lib.mkOption {
              description = "Port to serve the interface on";
              type = lib.types.port;
              example = 8080;
            };

            file = lib.mkOption {
              description = "Path to the sqlite database";
              type = lib.types.path;
              example = "/nix/var/nix/db/db.sqlite";
            };

            user = lib.mkOption {
              description = ''
                The user that owns the database file, and which
                the service should run under
              '';
              type = lib.types.str;
              example = "eve";
            };

            readOnly = lib.mkOption {
              description = "Do not allow editing the database via the interface";
              type = lib.types.bool;
              default = false;
              example = true;
            };

            passwordFile = lib.mkOption {
              description = ''
                File containing the password to use for authentication.
                Set to `null` to disable authentication
              '';
              type = lib.types.nullOr lib.types.path;
              default = null;
              example = "/run/keys/sqlite-web-password";
            };

            urlPrefix = lib.mkOption {
              description = "Prefix for all url paths";
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "/db/";
            };

            extraFlags = lib.mkOption {
              description = "Extra flags to pass to the sqlite-web command";
              type = with lib.types; either str (listOf str);
              default = [ ];
              example = [
                "--no-truncate"
                "--foreign-keys"
              ];
            };
          };
        }
      );

      default = { };
      example = {
        "nix-store-db" = {
          port = 8080;
          file = "/nix/var/nix/db/db.sqlite";
          readOnly = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = lib.attrsets.mapAttrs' (name: instance: {
      name = "sqlite-web-${name}";
      value = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "Web-based SQLite database browser written in Python";

        script = ''
          ${lib.optionalString (instance.passwordFile != null) ''
            export SQLITE_WEB_PASSWORD=$(cat "''${CREDENTIALS_DIRECTORY}/password")
          ''}

          ${lib.getExe cfg.package} ${
            lib.escapeShellArgs (
              [ "--port=${toString instance.port}" ]
              ++ lib.lists.optional (instance.urlPrefix != null) "--url-prefix=${instance.urlPrefix}"
              ++ lib.lists.optional (instance.passwordFile != null) "--password"
              ++ instance.extraFlags
              ++ [ instance.file ]
            )
          }
        '';

        serviceConfig = {
          LoadCredential = lib.optional (instance.passwordFile != null) "password:${instance.passwordFile}";

          # NOTE: Giving access to the entire directory might be wrong, but
          # I was sometimes getting errors without this.
          ReadOnlyPaths = lib.lists.optional instance.readOnly (builtins.dirOf instance.file);
          ReadWritePaths = lib.lists.optional (!instance.readOnly) (builtins.dirOf instance.file);
          User = instance.user;
          Restart = "on-failure";

          # Hardening
          AmbientCapabilities = "";
          CapabilityBoundingSet = "";
          DeviceAllow = "";
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
        };
      };
    }) cfg.databases;
  };
}
