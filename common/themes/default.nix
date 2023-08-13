{ inputs, ... }:
let
  themes = {
    catppuccin-mocha = {
      image = ./wallpapers/auto/catppuccin-mocha-rain-world.png;
      base16Scheme = "${inputs.catppuccin-base16}/base16/mocha.yaml";
      polarity = "dark";
    };

    catppuccin-latte = {
      # image = ./wallpapers/eye.png;
      image = ./wallpapers/watercag.png;
      base16Scheme = "${inputs.catppuccin-base16}/base16/latte.yaml";
      polarity = "light";
    };

    rosepine-dawn = {
      image = ./wallpapers/rosepine_light_field.png;
      base16Scheme = "${inputs.rosepine-base16}/rose-pine-dawn.yaml";
      polarity = "light";
    };

    gpt = {
      monopurple-light = {
        image = ./wallpapers/auto/catppuccin-latte-city.png;
        base16Scheme = ./gpt-themes/monopurple-light.yaml;
        polarity = "light";
      };

      purplepink-light = {
        image = ./wallpapers/auto/catppuccin-latte-city.png;
        base16Scheme = ./gpt-themes/purplepink-light.yaml;
        polarity = "light";
      };
    };
  };
in
{
  # Select your current theme here!
  imports = [
    { stylix = themes.catppuccin-latte; }
  ];

  # Requires me to manually turn targets on!
  stylix.autoEnable = false;
}
