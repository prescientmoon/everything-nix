# TODO: add maintainers and upstream into home-manager
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hyprpaper;
  mkWallpaper = { mode, image, monitor, ... }:
    let
      monitorString = lib.optionalString (monitor != null) monitor;
      modeString = lib.optionalString (mode == "contain") "contain:";
    in
    "wallpaper=${monitorString},${modeString}${image}";
in
{
  options.services.hyprpaper = {
    enable = mkEnableOption "hyprpaper";

    package = mkOption {
      type = types.package;
      default = pkgs.hyprpaper;
      defaultText = "pkgs.hyprpaper";
      description = ''
        hyprpaper derivation to use.
      '';
    };

    # TODO: what should the default value be for this?
    systemdTarget = mkOption {
      type = types.str;
      description = ''
        Systemd target to bind to.
      '';
    };

    preload = mkOption {
      type = types.listOf (types.oneOf [ types.str types.path ]);
      default = [ ];
      example = [ "~/background.png" ];
      description = "List of images to preload";
    };

    wallpapers = mkOption {
      type = types.listOf (types.submodule (_: {
        options = {
          monitor = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "eDP-1";
            description = ''
              Monitor to use for the wallpaper. 
              Either leave empty as a wildcard,
              type the name of the monitor, or
              include the monitor's description
              prefixed with `desc:`.
            '';
          };

          image = mkOption {
            type = types.oneOf [ types.str types.path ];
            default = null;
            example = "~/background.png";
            description = "Image to use as wallpaper";
          };

          mode = mkOption {
            type = lib.types.enum [ "cover" "contain" ];
            default = "cover";
            example = "contain";
            description = "The way to display the wallpaper";
          };
        };
      }));

      default = [ ];
      description = "List of wallpapers to set";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.hyprpaper" pkgs
        lib.platforms.linux)
    ];

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      ${lib.concatStringsSep "\n" (lib.forEach cfg.preload (image: "preload=${image}"))}
      ${lib.concatStringsSep "\n" (lib.forEach cfg.wallpapers mkWallpaper)}
    '';

    systemd.user.services.hyprpaper = {
      Unit = {
        Description = "Hyprland wallpaper daemon";
        Requires = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/hyprpaper";
      };

      Install = {
        WantedBy = [ cfg.systemdTarget ];
      };
    };
  };
}
