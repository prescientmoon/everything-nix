{ pkgs, lib, paths, config, ... }:
let
  base16-polybar = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-polybar";
    sha256 = "1jcr9mmy6y2g06w1b8211lc1y419hqg55v3ly0a27cjgvg89774c";
    rev = "47b7cc1cde79df5dc5e3cf8f9be607283eb5eb6e";
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
      include-file = ${config.scheme base16-polybar}

      ; Actual config
      include-file = ${./polybar.ini}
    '';
  };

  xsession = {
    enable = true;
    initExtra = script;
  };
}
