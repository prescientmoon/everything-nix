# Additional theming primitives not provided by stylix
{ lib, config, ... }:
let cfg = config.satellite.theming;
in
{
  options.satellite.theming = {
    transparency = {
      enable = lib.mkEnableOption "transparency for desktop apps";
      value = lib.mkOption {
        description = "How transparent windows should be by default";
        default = 1.0;
        example = 0.6;
        type = lib.types.float;
      };
    };

    rounding = {
      enable = lib.mkEnableOption "rounded corners for desktop apps";
      radius = lib.mkOption {
        description = "How much to round corners by deafault";
        default = 0;
        example = 10;
        type = lib.types.float;
      };
    };


    get = lib.mkOption {
      # No generics:(
      # The type of this is essentially (written in pseudocode):
      #
      # Record<String, T> 
      #   & { default?: T
      #         | {light?: T, dark?: T } }
      # -> Option<T>
      type = lib.types.functionTo lib.types.anything;
      description = "Index a theme map by the current theme";
    };

    colors = {
      rgb = lib.mkOption {
        type = lib.types.functionTo lib.types.str;
        description = "Returns comma separated rgb values for a color. To be used in css files:)";
      };

      rgba = lib.mkOption {
        type = lib.types.functionTo lib.types.str;
        description = ''
          Returns comma separated rgba values for a color.
          The transparency is taken from `options.satellite.theming.transparency`.
        '';
      };
    };
  };

  config.satellite.theming = {
    transparency.enable = cfg.transparency.value < 1.0;
    rounding.enable = cfg.rounding.radius > 0.0;

    get = themeMap:
      themeMap.${config.lib.stylix.scheme.scheme}
        or themeMap.default.${config.stylix.polarity or "dark"}
        or themeMap.default
        or (throw "Theme ${config.lib.stylix.scheme.scheme} not found in theme map!");

    colors.rgb = color: builtins.concatStringsSep "," [
      config.lib.stylix.scheme."${color}-rgb-r"
      config.lib.stylix.scheme."${color}-rgb-g"
      config.lib.stylix.scheme."${color}-rgb-b"
    ];

    colors.rgba = color: "${cfg.colors.rgb color},${toString cfg.transparency.value}";
  };
}
