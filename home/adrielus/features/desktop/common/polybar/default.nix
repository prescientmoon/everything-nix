{ pkgs, lib, paths, config, ... }:
let
  base16-polybar = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-polybar";
    sha256 = "142fmqm324gy3qsv48vijm5k81v6mw85ym9mmhnvyv2q2ndg5rix";
    rev = "2f6dd973a9075dabccd26f1cded09508180bf5fe";
  };
in
{
  services.polybar = {
    enable = true;
    extraConfig = ''
      ; Generated theme
      ${builtins.readFile (config.scheme base16-polybar)}

      ; Actual config
      include-file = ${paths.dotfiles}/polybar/config.ini
    '';
  };

  xsession = {
    enable = true;
    initExtra = ''
      polybar main &
    '';
  };
}
