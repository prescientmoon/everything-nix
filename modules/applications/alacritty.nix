{ ... }: {
  home-manager.users.adrielus.programs.alacritty = {
    enable = true;

    settings = {
      window = {
        decorations = "none";

        padding = {
          x = 8;
          y = 8;
        };

        gtk_theme_variant = "light";

      };

      # transparent bg:)
      background_opacity = 0.3;
      fonts.normal.family = "Source Code Pro";

      colors = {
        cursor = {
          text = "#c880b7";
          cursor = "#fcf68d";
        };
        selection = {
          text = "#b5b5b5";
          background = "#18354f";
        };
        primary = {
          background = "#f7fff7";
          foreground = "#18354f";
        };
        normal = {
          black = "#3d0a3b";
          red = "#c880b7";
          blue = "#6f38c7";
          yellow = "#8de336";
          green = "#2ec0f9";
          magenta = "#fc90c3";
          cyan = "#ff577e";
          white = "#e2e8ef";
        };
        bright = {
          black = "#5e105c";
          red = "#ec9ded";
          green = "#b726d4";
          yellow = "#fff773";
          blue = "#75d5fa";
          magenta = "#ffb3d7";
          cyan = "#ffcf66";
          white = "#ffffff";
        };
      };
    };
  };
}
