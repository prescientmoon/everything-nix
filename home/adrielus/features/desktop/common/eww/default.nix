{ config, pkgs, ... }:
let
  base16-eww = {
    template = builtins.readFile ./template.yuck;
  };

  widgets = config.satellite-dev.path "home/adrielus/features/desktop/common/eww/widgets";
in
{
  home.packages = [ pkgs.eww ];
  xdg.configFile."eww/eww.yuck".text = ''
    # Color scheme
    (include ${config.scheme base16-eww})

    # My widgets
    (include ${widgets}/dashboard)
  '';
}
