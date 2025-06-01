{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../global.nix
    ./hyprpaper.nix
  ];

  home.packages = [
    # Contains gtk-launch, which I use for launching 'obsidiantui'
    pkgs.gtk3
  ];

  stylix.targets.hyprland.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    # TODO: systemd-xdg-autostart-generator?
    # systemd.enable = false; # Handled by uwsm

    extraConfig = builtins.readFile ./hyprland.conf;
    settings = {
      # {{{ Decoration
      decoration = {
        rounding = config.satellite.theming.rounding.radius;
        active_opacity = 1;
        inactive_opacity = 1;

        blur = {
          enabled = config.satellite.theming.blur.enable;
          ignore_opacity = true;
          xray = true;
          size = config.satellite.theming.blur.size;
          passes = config.satellite.theming.blur.passes;
          contrast = config.satellite.theming.blur.contrast;
          brightness = config.satellite.theming.blur.brightness;
          noise = 5.0e-2;
        };
      };
      # }}}
      # {{{ Monitors
      # Configure monitor properties
      monitor = lib.forEach config.satellite.monitors (
        m:
        lib.concatStringsSep "," [
          m.name
          "${toString m.width}x${toString m.height}@${toString m.refreshRate}"
          "${toString m.x}x${toString m.y}"
          "1"
        ]
      );

      # Map monitors to workspaces
      workspace = lib.lists.concatMap (
        m: lib.lists.optional (m.workspace != null) "${m.name},${m.workspace}"
      ) config.satellite.monitors;
      # }}}

      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,36"
      ];
    };

    plugins = [ pkgs.hyprlandPlugins.hyprexpo ];
  };
}
