{ inputs, ... }:
let
  transparency = amount: {
    desktop = amount;
    applications = amount;
    terminal = amount;
    popups = amount;
  };

  themes = {
    # {{{ Catppuccin variants
    catppuccin-mocha = {
      stylix = {
        image = ./wallpapers/breaking_phos.jpg;
        base16Scheme = "${inputs.catppuccin-base16}/base16/mocha.yaml";
        opacity = transparency 0.7;
        polarity = "dark";
      };

      satellite = {
        rounding.radius = 8.0;
      };
    };

    catppuccin-latte = {
      stylix = {
        image = ./wallpapers/happy_phos.png;
        base16Scheme = "${inputs.catppuccin-base16}/base16/latte.yaml";
        opacity = transparency 0.6;
        polarity = "light";
      };

      satellite = {
        rounding.radius = 8.0;
      };
    };

    catppuccin-macchiato = {
      stylix = {
        image = ./wallpapers/lapis_lazuli.jpg;
        base16Scheme = "${inputs.catppuccin-base16}/base16/macchiato.yaml";
        opacity = transparency 0.7;
        polarity = "dark";
      };
      satellite = {
        rounding.radius = 8.0;
      };
    };
    # }}}
    # {{{ Rosepine variants
    rosepine-dawn = {
      stylix = {
        image = ./wallpapers/rosepine_light_field.png;
        base16Scheme = "${inputs.rosepine-base16}/rose-pine-dawn.yaml";
        polarity = "light";
      };
      satellite = { };
    };
    # }}}
    # {{{ Bluloco variants
    bluloco-light = {
      stylix = {
        image = ./wallpapers/watercag.png;
        base16Scheme = ./schemes/bluloco-light.yaml;
        opacity = transparency 0.6;
        polarity = "light";
      };

      satellite = {
        rounding.radius = 8.0;
      };
    };
    # }}}
    # {{{ Experiment: AI generated themes
    gpt = {
      monopurple-light = {
        stylix = {
          image = ./wallpapers/auto/catppuccin-latte-city.png;
          base16Scheme = ./schemes/gpt-themes/monopurple-light.yaml;
          polarity = "light";
        };
        satellite = { };
      };

      purplepink-light = {
        stylix = {
          image = ./wallpapers/spaceship.jpg;
          base16Scheme = ./schemes/gpt-themes/purplepink-light.yaml;
          transparency.alpha = 0.6;
          polarity = "light";
        };

        satellite = {
          rounding.radius = 8.0;
        };
      };
    };
    # }}}
  };

  # Select your current theme here!
  currentTheme = themes.catppuccin-macchiato;
in
{
  # We apply the current theme here.
  # The rest is handled by the respective modules!
  imports = [{
    stylix = currentTheme.stylix;
    satellite.theming = currentTheme.satellite;
  }];

  # Requires me to manually turn targets on!
  stylix.autoEnable = false;
}
