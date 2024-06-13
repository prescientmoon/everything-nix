# Generic interface for working specifying a single-source of truth for ports!
{ lib, ... }:
{
  options.satellite.ports = lib.mkOption {
    description = "Record of custom app-port mappings to use throughput the config";
    type = lib.types.lazyAttrsOf lib.types.port;
    default = { };
  };
}
