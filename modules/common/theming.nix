# Additional theming primitives not provided by stylix
{ lib, config, ... }:
let cfg = config.satellite.theming;
in
{
  options.satellite.theming = {
    rounding = {
      # Note: this is automatically set to true when the radius is strictly positive
      enable = lib.mkEnableOption "rounded corners for desktop apps";
      radius = lib.mkOption { default = 0; type = lib.types.int; };
    };

    # These pretty much directly map onto hypland options
    blur = {
      # Note: this is automatically set to true when the passes are strictly positive
      enable = lib.mkEnableOption "blurred backgrounds for desktop apps";

      passes = lib.mkOption { default = 4; type = lib.types.int; };
      brightness = lib.mkOption { default = 1.0; type = lib.types.float; };
      contrast = lib.mkOption { default = 1.2; type = lib.types.float; };
      size = lib.mkOption { default = 10; type = lib.types.int; };
    };

    get = lib.mkOption {
      # No generics:(
      # The type of this is essentially (written in ts-like -pseudocode):
      #
      # Record<String, T> 
      #   & { default?: T | {light?: T, dark?: T } }
      #   -> Option<T>
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
    rounding.enable = cfg.rounding.radius > 0;
    blur.enable = cfg.blur.passes > 0;

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

    colors.rgba = color: "${cfg.colors.rgb color},${toString config.stylix.opacity.applications}";
  };
}
