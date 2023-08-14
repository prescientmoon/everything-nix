{ config, ... }:
let
  base16-eww = config.lib.stylix.colors {
    template = builtins.readFile ./template.yuck;
  };

  widgets = config.satellite.dev.path "home/features/desktop/eww/widgets";
in
{
  programs.eww-hyprland = {
    enable = true;
    autoReload = true;
    extraConfig = ''
      ; Color scheme
      (include "${base16-eww}")

      ; My widgets
      (include "${widgets}/bar.yuck")
    '';
  };
}
