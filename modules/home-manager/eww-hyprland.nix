# A big chunk of this was taken from fuxefan's config:
# https://github.com/fufexan/dotfiles/blob/main/home/programs/eww/default.nix
{ config
, pkgs
, lib
, ...
}:
let
  reloadScript = pkgs.writeShellScript "reload_eww" ''
    systemctl --user restart eww.service
  '';

  cfg = config.programs.eww-hyprland;
in
{
  options.programs.eww-hyprland = {
    enable = lib.mkEnableOption "eww Hyprland config";

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.eww-wayland;
      defaultText = lib.literalExpression "pkgs.eww-wayland";
      description = "Eww package to use.";
    };

    autoReload = lib.mkOption {
      type = lib.types.bool;
      default = false;
      defaultText = lib.literalExpression "false";
      description = "Whether to restart the eww daemon and windows on change.";
    };

    dependencies = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      defaultText = lib.literalExpression "[]";
      description = "Extra packages eww should have access to.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = null;
      description = "Extra configuration for eww.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # remove nix files
    xdg.configFile."eww/eww.yuck" = {
      text = cfg.extraConfig or "";

      onChange =
        if cfg.autoReload
        then reloadScript.outPath
        else "";
    };

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath cfg.dependencies}";
        ExecStart = "${cfg.package}/bin/eww daemon --no-daemonize";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
