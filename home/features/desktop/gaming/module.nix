{
  config,
  lib,
  pkgs,
  upkgs,
  ...
}:
let
  cfg = config.satellite.games;
  wine = pkgs.wineWow64Packages.waylandFull;

  # {{{ Paths / other constants
  steamDir = "${config.xdg.dataHome}/Steam";
  historia = import ./historia { inherit pkgs; };
  historiaDbPath = "/persist/state${config.home.homeDirectory}/historia/db.sqlite";
  persistentStateDir = config.satellite.persistence.at.state.bounds.source;
  persistentCacheDir = config.satellite.persistence.at.cache.bounds.source;
  gamingStateDir = "${persistentStateDir}/gaming";

  protonPath = "UMU-Proton";

  wineUser = "moon";
  wineBase = "${config.xdg.dataHome}/satellite/gaming/prefixes";

  # I really need to abstract this away somewhere...
  concatPaths =
    paths:
    lib.optionalString (lib.hasPrefix "/" (lib.head paths)) "/"
    + lib.pipe paths [
      (lib.concatMap (builtins.split "/"))
      (lib.filter (s: builtins.typeOf s == "string" && s != ""))
      (lib.concatStringsSep "/")
    ];
  # }}}
  # {{{ Game options
  gameOptions =
    { config, name, ... }:
    {
      options = {
        pegasus = lib.mkEnableOption "pegasus integration" // {
          default = true;
        };

        id = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "The internal name for use in places like file paths.";
        };

        state = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = ''
            The name of the directory to use within
            /persist/state/home/???/gaming.
          '';
        };

        historiaId = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "The internal name for use in the historia database.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "The display-name for the game.";
        };

        file = lib.mkOption {
          type = lib.types.str;
          description = ''
            The executable that belongs to this game. The path must be relative
            to the game's state directory. Absolute paths can instead be given
            to the filePath option.
          '';
        };

        filePath = lib.mkOption {
          type = lib.types.str;
          defaultText = "derived from the entry's `file` option";
          description = "Full path to the game's executable.";
          default = concatPaths [ cfg.state config.state config.file ];
        };

        args = lib.mkOption {
          type = lib.types.listOf (
            lib.types.oneOf [
              lib.types.str
              lib.types.path
            ]
          );
          default = [ ];
          description = "Additional arguments to pass to the game executable.";
        };

        prefix = lib.mkOption {
          type = lib.types.str;
          default = "prefix";
          description = ''
            The name of the directory within the game's stateDir where the
            persistent paths should be stored. Not to be confused with
            `wine.prefix`! (this one applies to both wine and non-wine games!)
          '';
        };

        wine.prefix = lib.mkOption {
          type = lib.types.str;
          default = config.script;
          description = ''
            The name of the prefix to use for Windows games. The prefix data is
            stored in /persist/local/cache/home/???/gaming/prefixes/$name.
          '';
        };

        wine.subprefix = lib.mkOption {
          type = lib.types.str;
          default = config.id;
          description = ''
            The name of the subprefix to use for Windows games. The subprefix
            will be mounted to ~/.local/share/satellite/gaming/prefixes/$name.
          '';
        };

        paths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = ''
            List of paths inside that must be backed up. When using wine/umu,
            the paths are relative to the prefix' main directory. Otherwise,
            the paths are relative to ~.
          '';
        };

        script = lib.mkOption {
          default = null;
          type = lib.types.nullOr (lib.types.enum [ "steam-run" "umu" "wine" ]);
        };

        launch = lib.mkOption {
          type = lib.types.package;
          description = "A script that launches the game";
        };

        developers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "The developers of the game";
        };

        description = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "A possibly longer description of the game";
        };

        release = lib.mkOption {
          type = lib.types.nullOr lib.types.str;

          default = null;
          description = ''
            The date when the game was released, in YYYY-MM-DD format (eg.
            1985-05-22). Month and day can be omitted if unknown (eg. 1985-05
            or 1985 alone is also accepted)
          '';
        };

        assets =
          lib.attrsets.mapAttrs
            (
              _: description:
              lib.mkOption {
                inherit description;
                type = lib.types.nullOr lib.types.path;
                default = null;
              }
            )
            {
              logo = "The title art over a transparent background";
              poster = "Poster, usually with 2:3 aspect ratio";
              background = "A background image, eg. artwork or a screenshot";

              # Non-standard! We'll use this for generating XDG entries
              icon = "The desktop icon";
            };
      };

      config.launch =
        let
          protonOpts = lib.optionalAttrs
            (protonPath == "UMU-Proton")
            { PROTONPATH = protonPath; };

          wineVars = {
            WINEPREFIX = "${wineBase}/${config.wine.subprefix}";
            USER = wineUser;
          };

          envVars =
            if config.script == "umu" then
              wineVars // protonOpts
            else if config.script == "wine" then
              wineVars
            else
              { };

          command =
            if config.script == "umu" then
              [
                "${upkgs.umu-launcher}/bin/umu-run"
                config.filePath
              ]
            else if config.script == "wine" then
              [
                "${wine}/bin/wine"
                config.filePath
              ]
            else if config.script == "steam-run" then
              # NOTE: this doesn't work with `pkgs.steam-run`.
              # This could be because I add additional packages in `steam.nix`?
              [
                "steam-run"
                config.filePath
              ]
            else
              [ config.filePath ];
        in
        pkgs.writeShellScript "launch-${config.id}" ''
          set -euo pipefail
          cd "$(dirname "$(realpath "${config.filePath}")")"
          ${
            lib.pipe envVars [
              (lib.mapAttrsToList (k: v: ''${k}="${v}"''))
              (lib.concatStringsSep " ")
            ]
          } ${historia}/bin/historia ${historiaDbPath} "${config.historiaId}" \
            ${lib.escapeShellArgs (command ++ config.args)}
        '';
    };
  # }}}
  # {{{ Wine state persistence
  persistentDirectories = lib.concatMap (entry:
    lib.forEach entry.paths (path: {
      base = path;

      bounds.source = concatPaths [
        cfg.state
        entry.state
        entry.prefix
      ];

      bounds.target = lib.mkIf
        (entry.script == "wine" || entry.script == "umu")
        (concatPaths [
          wineBase
          entry.wine.subprefix
          "drive_c/users"
          wineUser
        ]);
    })
  ) (builtins.attrValues cfg.entries);
  # }}}
  # {{{ Wine prefix construction
  winePrefixDirectories = lib.pipe cfg.entries [
    builtins.attrValues
    (lib.filter (entry: entry.script == "umu" || entry.script == "wine"))
    (lib.map (entry: { inherit (entry.wine) prefix subprefix; }))
    lib.lists.unique
    (lib.map ({ prefix, subprefix }: {
      paths.source = concatPaths [
        persistentCacheDir
        "gaming/prefixes"
        prefix
        "drive_c/windows"
      ];

      paths.target = concatPaths [
        wineBase
        subprefix
        "drive_c/windows"
      ];
    }))
  ];
  # }}}
in
{
  options.satellite.games = {
    # {{{ Options
    enable = lib.mkEnableOption "satellite's game management";
    entries = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule gameOptions);
      default = { };
      description = "The games to include in the collection";
    };

    state = lib.mkOption {
      type = lib.types.str;
      default = gamingStateDir;
      readOnly = true;
    };
    # }}}
  };

  config = lib.mkIf cfg.enable {
    # {{{ Pegasus config file
    xdg.configFile = {
      "pegasus-frontend/metafiles/nix.metadata.pegasus.txt".text = ''
        collection: Nix
        shortname: linux

        ${lib.pipe cfg.entries [
          (lib.filterAttrs (_: entry: entry.pegasus))
          (lib.mapAttrsToList (
            _: entry:
            let
              inherit (lib.lists) forEach optional flatten;
              single =
                key: # .
                optional (entry.${key} != null) "${key}: ${entry.${key}}";
            in
            lib.concatStringsSep "\n" (
              [
                "game: ${entry.name}"
                "file: ${entry.filePath}"
              ]
              ++ forEach entry.developers (developer: "developer: ${developer}")
              ++ single "launch"
              ++ single "release"
              ++ single "description"
              ++ flatten (
                lib.mapAttrsToList (
                  name: value: # .
                  optional (value != null) "assets.${name}: ${value}"
                ) entry.assets
              )
            )
          ))
          (lib.concatStringsSep "\n\n")
        ]}
      '';
    };
    # }}}
    # {{{ State persistence
    satellite.persistence.at.state = {
      at.wine.directories = [ ".wine" ];
      at.pegasus.directories = [
        "${config.xdg.configHome}/pegasus-frontend"
      ];

      at.steam.directories = [ steamDir ];

      directories = persistentDirectories;
    };
    # }}}
    # {{{ Cache persistence
    satellite.persistence.at.cache = {
      at.umu.directories = [
        "${config.xdg.dataHome}/umu"
        "${config.xdg.cacheHome}/umu"
        "${config.xdg.cacheHome}/umu-protonfixes"
      ];

      directories = winePrefixDirectories;
    };
    # }}}
    # {{{ Directory scaffolding (should we really be using tmpfiles here?)
    systemd.user.tmpfiles.rules = [
      "d /persist/local/cache${config.xdg.dataHome}/umu"
      "d /persist/local/cache${config.xdg.cacheHome}/umu"
      "d /persist/local/cache${config.xdg.cacheHome}/umu-protonfixes"
    ];
    # }}}
    # {{{ Desktop entries
    xdg.desktopEntries = lib.mapAttrs (_: entry: {
      inherit (entry) name;
      icon = entry.assets.icon;
      type = "Application";
      categories = [ "Game" ];
      terminal = false;
      exec = toString entry.launch;
    }) cfg.entries;
    # }}}

    home.packages = [
      # {{{ Packages
      wine
      pkgs.pegasus-frontend
      # }}}
      # {{{ historia-stats
      (pkgs.writeShellScriptBin "historia-stats" ''
        if [ $# -eq 0 ]; then
          sqlite3 ${historiaDbPath} -table \
            "SELECT app, round(SUM(end - start) / 3600.0, 1) AS hours
             FROM timespans 
             GROUP BY app
             ORDER BY hours DESC"
        else
          sqlite3 ${historiaDbPath} -table \
            "SELECT datetime(start, 'auto') AS date,
                    round((end - start) / 60.0, 0) AS minutes
             FROM timespans
             WHERE app='$1'
             AND minutes >= 5"
        fi
      '')
      # }}}
    ];
  };
}
