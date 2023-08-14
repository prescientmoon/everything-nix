{ inputs, ... }:
let
  themes = {
    # {{{ Catppuccin variants
    catppuccin-mocha = {
      stylix = {
        image = ./wallpapers/auto/catppuccin-mocha-rain-world.png;
        base16Scheme = "${inputs.catppuccin-base16}/base16/mocha.yaml";
        polarity = "dark";
      };
      satellite = {
        transparency.value = 1.0;
      };
    };

    catppuccin-latte = {
      stylix = {
        # image = ./wallpapers/eye.png;
        image = ./wallpapers/watercag.png;
        base16Scheme = "${inputs.catppuccin-base16}/base16/latte.yaml";
        polarity = "light";
      };
      satellite = {
        transparency.value = 0.6;
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
      satellite = {
        transparency.value = 1.0;
      };
    };
    # }}}
    # {{{ Experiment: AI generated themes
    gpt = {
      monopurple-light = {
        stylix = {
          image = ./wallpapers/auto/catppuccin-latte-city.png;
          base16Scheme = ./gpt-themes/monopurple-light.yaml;
          polarity = "light";
        };
        satellite = {
          transparency.value = 1.0;
        };
      };

      purplepink-light = {
        stylix = {
          image = ./wallpapers/auto/catppuccin-latte-city.png;
          base16Scheme = ./gpt-themes/purplepink-light.yaml;
          polarity = "light";
        };
        satellite = {
          transparency.value = 1.0;
        };
      };
    };
    # }}}
  };

  # Select your current theme here!
  currentTheme = themes.catppuccin-latte;
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
