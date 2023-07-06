{ pkgs, lib, config, inputs, ... }:

let
  enabledMonitors = lib.filter (m: m.enabled) config.monitors;
  hyprland-monitors = lib.concatStringsSep "\n" (lib.forEach enabledMonitors (m: ''
    monitor=${m.name},${toString m.width}x${toString m.height}@${toString m.refreshRate},${toString m.x}x${toString m.y},1
    ${lib.optionalString (m.workspace != null) "workspace=${m.name},${m.workspace}"}
  ''));
in
{
  imports = [ ../default.nix ];

  home.packages = [ inputs.hyprland-contrib.packages.${pkgs.system}.grimblast pkgs.hyprpaper ];

  wayland.windowManager.hyprland = {
    enable = true;
    recommendedEnvironment = true;
    extraConfig = ''
      ${builtins.readFile ./hyprland.conf}
      ${hyprland-monitors}
    '';
  };

  services.hyprpaper = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    preload = [ config.stylix.image ];
    wallpapers = [{ inherit (config.stylix) image; }] ++
      lib.forEach enabledMonitors ({ name, ... }: {
        monitor = name;
        image = config.stylix.image;
      });
  };
}
