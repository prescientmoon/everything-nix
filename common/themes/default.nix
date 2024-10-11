{ inputs, ... }:
let
  transparency = amount: {
    desktop = amount;
    applications = amount;
    terminal = amount;
    popups = amount;
  };

  base16 = name: "${inputs.base16-schemes}/base16/${name}.yaml";

  themes = {
    # {{{ Catppuccin mocha
    catppuccin-mocha = {
      stylix = {
        image = ./wallpapers/purplecliffs.jpg;
        base16Scheme = base16 "catppuccin-mocha";
        opacity = transparency 0.7;
        polarity = "dark";
      };
      satellite.rounding.radius = 8;
    };
    # }}}
    # {{{ Catppuccin latte
    catppuccin-latte = {
      stylix = {
        image = ./wallpapers/needygirloverdose.jpg;
        base16Scheme = base16 "catppuccin-latte";
        opacity = transparency 0.7;
        polarity = "light";
      };
      satellite.rounding.radius = 8;
    };
    # }}}
    # {{{ Catppuccin macchiato
    catppuccin-macchiato = {
      stylix = {
        image = ./wallpapers/gabriel.jpg;
        base16Scheme = base16 "catppuccin-macchiato";
        opacity = transparency 0.7;
        polarity = "dark";
      };
      satellite.rounding.radius = 8;
    };
    # }}}
    # {{{ Rosepine dawn
    rosepine-dawn = {
      stylix = {
        image = ./wallpapers/rosepine_light_field.png;
        base16Scheme = base16 "rose-pine-dawn";
        polarity = "light";
      };
      satellite = { };
    };
    # }}}
    # {{{ Gruvbox light
    gruvbox-light = {
      stylix = {
        image = ./wallpapers/sketchy-peaks.png;
        base16Scheme = base16 "gruvbox-light-soft";
        opacity = transparency 0.7;
        polarity = "light";
      };
      satellite.rounding.radius = 8;

      # For this one, I went with a big size, which means the blur just adds a slight gradient to the backgrounds.
      satellite.blur = {
        brightness = 1.05;
        size = 25;
      };
    };
    # }}}
    # {{{ Gruvbox dark
    gruvbox-dark = {
      stylix = {
        image = ./wallpapers/sad_hikari.png;
        base16Scheme = base16 "gruvbox-dark-soft";
        opacity = transparency 0.7;
        polarity = "dark";
      };
      satellite.rounding.radius = 8;
    };
    # }}}
  };

  # Select your current theme here!
  currentTheme = themes.catppuccin-mocha;
in
{
  # We apply the current theme here.
  # The rest is handled by the respective modules!
  imports = [
    {
      stylix = currentTheme.stylix;
      satellite.theming = currentTheme.satellite;
    }
  ];

  # Requires me to manually turn targets on!
  stylix.autoEnable = false;
}
