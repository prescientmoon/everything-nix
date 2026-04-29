{
  config,
  lib,
  pkgs,
  upkgs,
  ...
}:
let
  cfg = config.satellite.games;

  steamDir = "${config.xdg.dataHome}/Steam";
  historia = import ./historia { inherit pkgs; };
  historiaDbPath = "/persist/state${config.home.homeDirectory}/historia/db.sqlite";
  persistentStateDir = lib.concatStrings [
    config.satellite.persistence.at.state.path
    config.home.homeDirectory
  ];

  gameDir = "${config.home.homeDirectory}/media/games";
  heroicGameDir = "${gameDir}/heroic";
  heroicConfigDir = "${config.xdg.configHome}/heroic";
  heroicDataDir = "${config.xdg.dataHome}/heroic";
  # protonPath = "${heroicConfigDir}/tools/proton/GE-Proton-latest";
  protonPath = "UMU-Proton";

  gameOptions =
    { config, name, ... }:
    {
      options = {
        id = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "The internal name for use in places like file paths.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "The display-name for the game.";
        };

        file = lib.mkOption {
          type = lib.types.oneOf [
            lib.types.str
            lib.types.path
          ];
          description = "The file that belongs to this game.";
        };

        winePrefix = lib.mkOption {
          type = lib.types.oneOf [
            lib.types.str
            lib.types.path
          ];
          description = "The prefix location for games that run inside WINE.";
          default = "${persistentStateDir}/${config.id}/prefix";
        };

        script = lib.mkOption {
          default = null;
          type = lib.types.nullOr (
            lib.types.enum [
              "steam-run"
              "umu"
            ]
          );
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
              screenshot = "An in-game screenshot";

              # Non-standard! We'll use this for generating XDG entries
              icon = "The desktop icon";
            };
      };

      config.launch =
        let
          envVars =
            if config.script == "umu" then
              {
                WINEPREFIX = config.winePrefix;
              }
              // (if protonPath == "UMU-Proton" then { } else { PROTONPATH = protonPath; })
            else
              { };

          command =
            if config.script == "umu" then
              [
                "${pkgs.umu-launcher}/bin/umu-run"
                config.file
              ]
            else if config.script == "steam-run" then
              # NOTE: this doesn't work with `pkgs.steam-run`.
              # This could be because I add additional packages in `steam.nix`?
              [
                "steam-run"
                config.file
              ]
            else
              [ config.file ];
        in
        pkgs.writeShellScript "launch-${config.id}" ''
          set -euo pipefail
          cd "$(dirname "$(realpath "${config.file}")")"
          ${
            lib.pipe envVars [
              (lib.mapAttrsToList (k: v: ''${k}="${v}"''))
              (lib.concatStringsSep " ")
            ]
          } ${historia}/bin/historia ${historiaDbPath} "${config.id}" \
            ${lib.escapeShellArgs command}
        '';
    };

  symlinkAll = lib.map (directory: {
    inherit directory;
    method = "symlink";
  });
in
{
  options.satellite.games = {
    enable = lib.mkEnableOption "satellite's game management";
    entries = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule gameOptions);
      default = { };
      description = "The games to include in the collection";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "pegasus-frontend/metafiles/nix.metadata.pegasus.txt".text = ''
        collection: Nix
        shortname: linux

        ${lib.pipe cfg.entries [
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
                "file: ${entry.file}"
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

    satellite.persistence.at.state.apps = {
      wine.directories = [ ".wine" ];
      pegasus.directories = [
        "${config.xdg.configHome}/pegasus-frontend"
      ];

      steam.directories = symlinkAll [ steamDir ];

      heroic.directories = symlinkAll [
        heroicConfigDir
        heroicGameDir

        # I store wine prefixes here (will try to move them out though)
        heroicDataDir
      ];

      # There might be more to cache in `.cache/lutris`, but this works for now
      lutris.directories = symlinkAll [
        "${config.xdg.configHome}/lutris" # General configuration data
        "${config.xdg.cacheHome}/lutris/banners" # Game banners
        "${config.xdg.cacheHome}/lutris/coverart" # Game cover art
        "${gameDir}/lutris"
      ];
    };

    satellite.persistence.at.cache.apps = {
      umu.directories = symlinkAll [
        "${config.xdg.dataHome}/umu"
        "${config.xdg.cacheHome}/umu"
        "${config.xdg.cacheHome}/umu-protonfixes"
      ];
    };

    systemd.user.tmpfiles.rules = [
      "d /persist/local/cache/umu${config.xdg.dataHome}/umu"
      "d /persist/local/cache/umu${config.xdg.cacheHome}/umu"
      "d /persist/local/cache/umu${config.xdg.cacheHome}/umu-protonfixes"
    ];

    xdg.desktopEntries = lib.mapAttrs (_: entry: {
      inherit (entry) name;
      icon = entry.assets.icon;
      type = "Application";
      categories = [ "Game" ];
      terminal = false;
      exec = toString entry.launch;
    }) cfg.entries;

    home.packages = [
      pkgs.lutris
      pkgs.wine64
      pkgs.pegasus-frontend
      (upkgs.heroic.override {
        extraPkgs = pkgs: [
          pkgs.gamescope
          pkgs.gamemode
        ];
      })
    ];
  };
}
