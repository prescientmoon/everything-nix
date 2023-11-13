{ lib, ... }:
{
  options.satellite.toggles = lib.mkOption {
    default = { };
    description = "Record of custom toggles to use throughput the config";
    type = lib.types.attrsOf (lib.types.submodule (name: {
      options.enable = lib.mkEnableOption "Toggle for ${name}";
    }));
  };
}
