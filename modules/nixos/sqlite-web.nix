{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.satellite.sqliteWeb;
in
{
  options.satellite.sqliteWeb = {
    databases = lib.mkOption {
      description = "Per-database sqlite-web configuration";
      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }:
          {
            options.port = lib.mkOption {
              description = "Port to serve UI on";
              type = lib.types.nullOr lib.types.port;
              default = null;
            };

            options.user = lib.mkOption {
              description = "The user the GUI should run as";
              type = lib.types.str;
            };

            options.group = lib.mkOption {
              description = "The group the GUI should run as";
              type = lib.types.str;
            };

            options.file = lib.mkOption {
              description = "Path to serve files from";
              type = lib.types.path;
            };

            options.passwordFile = lib.mkOption {
              description = "File containing the password to use for authentication";
              type = lib.types.nullOr lib.types.path;
              default = null;
            };

            options.location = lib.mkOption {
              description = "Prefix path to add to all urls";
              type = lib.types.path;
              default = "";
            };
          }
        )
      );

      default = { };
    };
  };

  config.systemd.services = lib.attrsets.mapAttrs' (name: value: {
    name = "sqlite-web-${name}";
    value = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Sqlite web GUI";

      serviceConfig = {
        User = value.user;
        Group = value.user;
        ExecStart = pkgs.writeShellScript "sqlite-web-startup" ''
          export SQLITE_WEB_PASSWORD=$(cat ${value.passwordFile})

          ${lib.getExe pkgs.sqlite-web} \
            --port=${toString value.port} \
            --url-prefix=${value.location} \
            --password \
            --no-browser \
            ${value.file}
        '';
        Restart = "on-failure";
      };
    };
  }) cfg.databases;
}
