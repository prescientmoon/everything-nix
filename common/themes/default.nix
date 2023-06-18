{ inputs, ... }:
let
  themes = {
    catppuccin-mocha = {
      image = ./wallpapers/auto/catppuccin-mocha-rain-world.png;
      base16Scheme = "${inputs.catppuccin-base16}/base16/mocha.yaml";
    };
    rosepine-dawn = {
      image = ./wallpapers/rosepine_light_field.png;
      base16Scheme = "${inputs.rosepine-base16}/rose-pine-dawn.yaml";
    };
  };
in
{
  # Select your current theme here!
  imports = [
    { stylix = themes.catppuccin-mocha; }
  ];

  # Requires me to manually turn targets on!
  stylix.autoEnable = false;
}
