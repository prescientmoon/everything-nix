# Lua file containing the current colorscheme.
{ lib, config, ... }: {
  options.satellite.colorscheme.lua = lib.mkOption {
    type = lib.types.lines;
    description = "Lua file containing the current colorscheme";
  };

  config.satellite.colorscheme.lua = ''
    return {
      name = "${config.lib.stylix.scheme.scheme}",
      base00 = "${config.lib.stylix.scheme.base00}",
      base01 = "${config.lib.stylix.scheme.base01}",
      base02 = "${config.lib.stylix.scheme.base02}",
      base03 = "${config.lib.stylix.scheme.base03}",
      base04 = "${config.lib.stylix.scheme.base04}",
      base05 = "${config.lib.stylix.scheme.base05}",
      base06 = "${config.lib.stylix.scheme.base06}",
      base07 = "${config.lib.stylix.scheme.base07}",
      base08 = "${config.lib.stylix.scheme.base07}",
      base09 = "${config.lib.stylix.scheme.base09}",
      base0A = "${config.lib.stylix.scheme.base0A}",
      base0B = "${config.lib.stylix.scheme.base0B}",
      base0C = "${config.lib.stylix.scheme.base0C}",
      base0D = "${config.lib.stylix.scheme.base0D}",
      base0E = "${config.lib.stylix.scheme.base0E}",
      base0F = "${config.lib.stylix.scheme.base0F}",
      -- TODO: check if this works with the genetic algorithm
      source = "${config.stylix.base16Scheme}",
      fonts = {
        normal = "${config.stylix.fonts.sansSerif.name}",
        monospace = "${config.stylix.fonts.monospace.name}"
      },
      transparency = {
        enable = ${toString config.satellite.theming.transparency.enable} == 1,
        value = ${toString config.satellite.theming.transparency.alpha},
      },
      rounding = {
        enable = ${toString config.satellite.theming.rounding.enable} == 1,
        radius = ${toString config.satellite.theming.rounding.radius},
      }
    }
  '';
}
