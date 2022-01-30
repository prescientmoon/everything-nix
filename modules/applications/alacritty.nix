{ pkgs, ... }:

let
  githubAlacrittyTheme =
    "${pkgs.githubNvimTheme}/terminal/alacritty/github_light.yml";
in {
  home-manager.users.adrielus.programs.alacritty = {
    enable = true;

    settings = {
      import = [ githubAlacrittyTheme ];

      window = {
        decorations = "none";

        padding = {
          x = 8;
          y = 8;
        };

        gtk_theme_variant = "light";
      };

      # transparent bg:)
      background_opacity = 0.6;
      fonts.normal.family = "Source Code Pro";
    };
  };
}
