# Lua file containing the current colorscheme.
{ lib, config, inputs, ... }: {
  options.satellite.colorscheme.lua = lib.mkOption {
    type = lib.types.lines;
    description = "Lua file containing the current colorscheme";
  };

  config.satellite.colorscheme.lua =
    let
      e = import ./korora-lua.nix {
        inherit lib;
        korora = inputs.korora.lib;
      };

      theme = {
        name = config.lib.stylix.scheme.scheme;
        base00 = config.lib.stylix.scheme.base00;
        base01 = config.lib.stylix.scheme.base01;
        base02 = config.lib.stylix.scheme.base02;
        base03 = config.lib.stylix.scheme.base03;
        base04 = config.lib.stylix.scheme.base04;
        base05 = config.lib.stylix.scheme.base05;
        base06 = config.lib.stylix.scheme.base06;
        base07 = config.lib.stylix.scheme.base07;
        base08 = config.lib.stylix.scheme.base07;
        base09 = config.lib.stylix.scheme.base09;
        base0A = config.lib.stylix.scheme.base0A;
        base0B = config.lib.stylix.scheme.base0B;
        base0C = config.lib.stylix.scheme.base0C;
        base0D = config.lib.stylix.scheme.base0D;
        base0E = config.lib.stylix.scheme.base0E;
        base0F = config.lib.stylix.scheme.base0F;
        # TODO: check if this works with the genetic algorithm
        source = config.stylix.base16Scheme;
        fonts = {
          serif = config.stylix.fonts.serif.name;
          sansSerif = config.stylix.fonts.sansSerif.name;
          monospace = config.stylix.fonts.monospace.name;
        };
        opacity = {
          terminal = config.stylix.opacity.terminal;
          applications = config.stylix.opacity.applications;
          desktop = config.stylix.opacity.desktop;
          popups = config.stylix.opacity.popups;
        };
        # Whether to enable transparency for different targets
        transparent = {
          terminal = config.stylix.opacity.terminal < 1.0;
          applcations = config.stylix.opacity.applications < 1.0;
          desktop = config.stylix.opacity.desktop < 1.0;
          popups = config.stylix.opacity.popups < 1.0;
        };
        rounding = {
          enable = config.satellite.theming.rounding.enable;
          radius = config.satellite.theming.rounding.radius;
        };
      };
    in
    e.encode theme;
}
