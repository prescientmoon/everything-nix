{ pkgs, lib, paths, config, ... }:
let
  base16-polybar = config.lib.stylix.colors {
    template = builtins.readFile ./template.mustache;
  };

  script = ''
    polybar main &
  '';
in
{
  services.polybar = {
    enable = true;
    script = ""; # Otherwise this tries starting on wayland
    extraConfig = ''
      ; Generated theme
      include-file = ${base16-polybar}

      ; Consistent fonts
      [fonts]
      regular = "${config.stylix.fonts.sansSerif.name}"
      monospace = "${config.stylix.fonts.monospace.name}"

      ; Actual config
      ${builtins.readFile ./polybar.ini}
    '';
  };

  xsession = {
    enable = true;
    initExtra = script;
  };
}
