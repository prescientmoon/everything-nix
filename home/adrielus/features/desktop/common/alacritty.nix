{ config, pkgs, ... }:
let base16-alacritty = pkgs.fetchFromGitHub {
  owner = "aarowill";
  repo = "base16-alacritty";
  sha256 = "0zibl9kzazckkyzb6j0iabrl82r1kgwg8ndqpy7dz0kwmj42wfx0";
  rev = "914727e48ebf3eab1574e23ca0db0ecd0e5fe9d0";
};
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      import = [ (config.scheme base16-alacritty) ];

      window.decorations = "none";
      window.padding = {
        x = 4;
        y = 4;
      };

      fonts.normal.family = config.fontProfiles.monospace.family;

      env = { TERM = "xterm-256color"; };
      working_directory = "${config.home.homeDirectory}/Projects/";
    };
  };
}
