{ pkgs, lib, paths, config, ... }:
let
  base16-polybar = {
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
      ${builtins.readFile (config.scheme base16-polybar)}

      ; Consistent fonts
      [fonts]
      regular = "${config.fontProfiles.regular.family}"
      monospace = "${config.fontProfiles.monospace.family}"

      ; Actual config
      ${builtins.readFile ./polybar.ini}
    '';
  };

  xsession = {
    enable = true;
    initExtra = script;
  };
}
