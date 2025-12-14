{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.pegasus-frontend;

  gameOptions =
    { config, name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "The display-name for the game";
        };

        file = lib.mkOption {
          type = lib.types.oneOf [
            lib.types.str
            lib.types.path
          ];
          description = "The file that belongs to this game";
        };

        developers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "The developers of the game";
        };

        tags = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "Co-op"
            "VRwnl"
          ];
          description = "Tags to apply to this game";
        };

        summary = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "A short description of the game in one paragraph";
        };

        description = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "A possibly longer description of the game";
        };

        players = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "The number of players who can play the game. Either a single number (eg. 2) or a number range (eg. 1-4)";
        };

        release = lib.mkOption {
          type = lib.types.nullOr lib.types.str;

          default = null;
          description = "The date when the game was released, in YYYY-MM-DD format (eg. 1985-05-22). Month and day can be omitted if unknown (eg. 1985-05 or 1985 alone is also accepted)";
        };

        launch = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.path
              lib.types.package
            ]
          );
          default = null;
          description = "If this game must be launched differently than the others in the same collection, a custom launch command can be defined for it";
        };

        definition = lib.mkOption {
          type = lib.types.lines;
          description = "The complete textual definition to be added to the collection";
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
              boxFront = "The front of the game box";
              boxBack = "The back of the game box";
              boxSpine = "The spine (side edge) of the game box";
              boxFull = "Full box art (front + back + spine)";
              cartridge = "Image of the game medium (cartridge, floppy, disk, etc.)";
              logo = "The game's logo, usually the title art over a transparent background";
              poster = "Advertisement poster, usually with 2:3 aspect ratio (in general a portrait-aligned image";

              marquee = "A wide (often over 3:1) artwork on the top of arcade machines";
              bazel = "Decoration around a game's screen on an arcade machine or emulator";
              panel = "Control panel of the arcade machine";
              cabinetLeft = "Left side of the arcade machine";
              cabinetRight = "Right side of the arcade machine";

              title = "A square-sized image (not the desktop icon)";
              banner = "An image in 16:9 aspect ratio";
              steam = "Steam grid icon, in 460x215px or 920x430px size";
              background = "A background image, eg. artwork or selected screenshot";
              music = "Background music";
              screenshot = "An in-game screenshot";
              titlescreen = "An in-game screenshot of the title screen or main menu of the game";
              video = "A video about the game, eg. a trailer or gameplay presentation";
            };
      };

      config.definition = lib.concatStringsSep "\n" (
        [
          "game: ${config.name}"
          "file: ${config.file}"
        ]
        ++ lib.lists.forEach config.developers (developer: "developer: ${developer}")
        ++ lib.lists.forEach config.tags (tag: "tag: ${tag}")
        ++ lib.lists.optional (config.launch != null) "launch: ${config.launch}"
        ++ lib.lists.optional (config.summary != null) "summary: ${config.summary}"
        ++ lib.lists.optional (config.description != null) "description: ${config.description}"
        ++ lib.lists.optional (config.release != null) "release: ${config.release}"
        ++ lib.lists.optional (config.players != null) "players: ${config.players}"
        ++ lib.lists.flatten (
          lib.mapAttrsToList (
            name: value: lib.lists.optional (value != null) "assets.${name}: ${value}"
          ) config.assets
        )
      );
    };

  collectionOptions =
    { config, name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "The display-name for the collection";
        };

        shortname = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "An optional short name for the collection, in lowercase. Often an abbreviation, like MAME, NES, etc. By default, matches the name of the collection";
        };

        directories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "A list of directories containing files relevant to the collection";
        };

        summary = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "A short description of the collection in one paragraph";
        };

        description = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "A possibly longer description of the collection";
        };

        games = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule gameOptions);
          default = { };
          description = "The games to include in the collection";
        };

        definition = lib.mkOption {
          type = lib.types.lines;
          description = "The complete textual metadata of the collection";
        };
      };

      config.definition = lib.concatStringsSep "\n" (
        [
          "collection: ${config.name}"
        ]
        ++ lib.lists.optional (config.shortname != null) "shortname: ${config.shortname}"
        ++ lib.lists.optional (config.summary != null) "summary: ${config.summary}"
        ++ lib.lists.optional (config.description != null) "description: ${config.description}"
        ++ lib.lists.forEach config.directories (directory: "directory: ${directory}")
        ++ lib.mapAttrsToList (_: game: "\n${game.definition}") config.games
      );
    };
in
{
  meta.maintainers = with lib.hm.maintainers; [
    prescientmoon
  ];

  options.programs.pegasus-frontend = {
    enable = lib.mkEnableOption "pegasus-frontend, the game launcher";
    package = lib.mkPackageOption pkgs "pegasus-frontend" { nullable = true; };
    collections = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule collectionOptions);
      default = { };
      description = "Additional collections to load metadata for";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    xdg.configFile."pegasus-frontend/metafiles/nix.metadata.pegasus.txt".text =
      lib.concatStringsSep "\n\n"
        (lib.mapAttrsToList (_: collection: "${collection.definition}") cfg.collections);
  };
}
