# Generic interface for working with feature flags!
#
# For instance, my neovim config sets `programs.neovim.enable` to `false`,
# so other modules cannot detect whether it is on or off without doing weird
# tricks like checking if certain attributes have been set.
#
# Instead, the neovim config sets `satellite.toggles.neovim.enable` to `true`,
# which can then be read from places like the firefox config to trigger things
# like installing the `firenvim` extension.
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
