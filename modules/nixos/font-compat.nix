{ lib, config, ... }: {
  options.fonts.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
  };

  config.fonts.fonts = config.fonts.packages;
}
