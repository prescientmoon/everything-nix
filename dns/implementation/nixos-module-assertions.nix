# This must only be loaded on actual Nixos, otherwise `assertions`
# won't be defined when running `evaluateModules`.
{ config, ... }:
let
  cfg = config.satellite.dns;
in
{
  config.assertions =
    let
      assertProperToUsage = config: {
        assertion =
          (config.to == null) # .
          || (config.type == "CNAME")
          || (config.type == "ALIAS");
        message = ''
          The option `satellite.dns.records[*].to` can only be used with `CNAME`
          or `ALIAS` records. This was not the case for ${config.type} record at
          ${config.at}.${config.zone}.
        '';
      };
    in
    map assertProperToUsage cfg.records;
}
