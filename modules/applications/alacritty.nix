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
      background_opacity = 0.6;
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
          background = "#d1d5ff";
          foreground = "#18354f";
        };
        normal = {
          black = "#3d0a3b";
          red = "#c880b7";
          blue = "#6f38c7";
          yellow = "#8de336";
          green = "#00a3e3";
          magenta = "#ff4a9f";
          cyan = "#ff577e";
          white = "#e2e8ef";
        };
        bright = {
          black = "#5e105c";
          red = "#b32ab5";
          green = "#2ec0f9";
          # green = "#b726d4";
          yellow = "#ded433";
          blue = "#4fb4db";
          magenta = "#b58297";
          cyan = "#ffcf66";
          white = "#ffffff";
        };
      };
    };
  };
}
