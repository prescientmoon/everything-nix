{
  config,
  pkgs,
  lib,
  ...
}:
let
  format = pkgs.formats.yaml { };
  cfg = config.satellite.dns;
in
{
  options.satellite.dns = {
    domain = lib.mkOption {
      description = "Default zone to include records in";
      type = lib.types.str;
    };

    records = lib.mkOption {
      description = "List of records to create";
      default = [ ];
      type = lib.types.listOf (
        lib.types.submodule (
          { config, ... }:
          {
            options = {
              at = lib.mkOption {
                description = "Subdomain to use for entry";
                type = lib.types.nullOr lib.types.str;
              };

              zone = lib.mkOption {
                description = "Zone this record is a part of";
                type = lib.types.str;
                default = cfg.domain;
              };

              type = lib.mkOption {
                type = lib.types.enum [
                  "A"
                  "AAAA"
                  "TXT"
                  "CNAME"
                  "MX"
                ];
                description = "The type of the DNS record";
              };

              to = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "Shorthand for CNMAE-ing to a subdomain of the given zone";
                default = null;
              };

              value = lib.mkOption {
                type = format.type;
                description = "The value assigned to the record, in octodns format";
              };

              ttl = lib.mkOption {
                type = lib.types.int;
                description = "The TTL assigned to the record";
                default = 300;
              };

              enableCloudflareProxy = lib.mkEnableOption "proxying using cloudflare";
            };

            config.value = lib.mkIf (
              config.type == "CNAME" && config.to != null
            ) "${config.to}.${config.zone}.";
          }
        )
      );
    };
  };
}
