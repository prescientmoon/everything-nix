{ ... }: {
  home-manager.users.adrielus.programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 4;
          y = 8;
        };

        gtk_theme_variant = "dark";
      };

      fonts.normal.family = "Source Code Pro";

      # transparent bg:)
      background_opacity = 0.7;

      colors = {
        cursor = {
          text = "#1460d2";
          cursor = "#f0cc09";
        };
        selection = {
          text = "#b5b5b5";
          background = "#18354f";
        };
        primary = {
          background = "#132738";
          foreground = "#ffffff";
        };
        normal = {
          black = "#000000";
          red = "#ff0000";
          green = "#38de21";
          yellow = "#ffe50a";
          blue = "#1460d2";
          magenta = "#ff005d";
          cyan = "#00bbbb";
          white = "#bbbbbb";
        };
        bright = {
          black = "#555555";
          red = "#f40e17";
          green = "#3bd01d";
          yellow = "#edc809";
          blue = "#5555ff";
          magenta = "#ff55ff";
          cyan = "#6ae3fa";
          white = "#ffffff";
        };
      };
    };
  };
}
