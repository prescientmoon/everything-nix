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
      satellite = { };
    };

    catppuccin-latte = {
      stylix = {
        image = ./wallpapers/needygirloverdose.jpg;
        base16Scheme = "${inputs.catppuccin-base16}/base16/latte.yaml";
        polarity = "light";
      };
      satellite = {
        transparency.alpha = 0.6;
        rounding.radius = 8.0;
      };
    };

    catppuccin-macchiato = {
      stylix = {
        image = ./wallpapers/lapis_lazuli.jpg;
        base16Scheme = "${inputs.catppuccin-base16}/base16/macchiato.yaml";
        polarity = "dark";
      };
      satellite = {
        transparency.alpha = 0.7;
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
        polarity = "light";
      };
      satellite = {
        transparency.alpha = 0.6;
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
          image = ./wallpapers/needygirloverdose.jpg;
          base16Scheme = ./schemes/gpt-themes/purplepink-light.yaml;
          polarity = "light";
        };
        satellite = {
          transparency.alpha = 0.6;
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
