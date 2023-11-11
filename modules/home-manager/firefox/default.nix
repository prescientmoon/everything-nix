# Allows installing web apps as desktop apps
{ lib, config, ... }:
let cfg = config.programs.firefox.apps;
in
{
  options.programs.firefox.apps = {
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = "Extensions to install for all apps";
      default = [ ];
    };

    app = lib.mkOption {
      default = { };
      description = "Attr set of firefox web apps to install as desktop apps";
      type = lib.types.attrsOf
        (lib.types.submodule ({ name, ... }: {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "The name of the app";
              default = name;
            };

            id = lib.mkOption {
              type = lib.types.int;
              description = "The id of the firefox profile for the app";
              example = 3;
            };

            displayName = lib.mkOption {
              type = lib.types.str;
              description = "The name of the app in stuff like menus";
              default = name;
            };

            url = lib.mkOption {
              type = lib.types.str;
              description = "The url the app should point to";
              example = "https://example.com";
            };

            icon = lib.mkOption {
              type = lib.types.path;
              description = "The icon to use for the app";
            };

            extensions = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              description = "Extensions to install for this app";
              default = [ ];
            };
          };
        }));
    };
  };

  config =
    let
      mkProfile = app: {
        settings = {
          # Customize css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Set language to english
          "general.useragent.locale" = "en-GB";
        };

        userChrome = builtins.readFile ./theme.css;
        extensions = cfg.extensions ++ app.extensions;
        isDefault = false;
        id = app.id;
      };

      mkDesktopEntry = app: {
        terminal = false;
        name = app.displayName;
        type = "Application";
        exec = "firefox --name=${app.displayName} --no-remote -P \"${app.name}\" \"${app.url}\"";
        icon = app.icon;
      };
    in
    {
      programs.firefox.profiles = lib.mapAttrs (_: mkProfile) cfg.app;
      xdg.desktopEntries = lib.mapAttrs (_: mkDesktopEntry) cfg.app;
    };
}
