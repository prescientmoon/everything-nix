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
    inherit script;
    enable = true;
    extraConfig = ''
      ; Generated theme
      ${builtins.readFile base16-polybar}

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
