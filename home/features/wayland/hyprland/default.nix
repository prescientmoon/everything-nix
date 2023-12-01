{ pkgs, lib, config, inputs, ... }:

let
  hyprland-monitors = lib.concatStringsSep "\n" (lib.forEach config.satellite.monitors (m: ''
    monitor=${m.name},${toString m.width}x${toString m.height}@${toString m.refreshRate},${toString m.x}x${toString m.y},1
    ${lib.optionalString (m.workspace != null) "workspace=${m.name},${m.workspace}"}
  ''));
in
{
  imports = [ ../global.nix ./hyprpaper.nix ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = { };
    extraConfig = ''
      ${builtins.readFile ./hyprland.conf}
      ${hyprland-monitors}
    '';
  };
}
