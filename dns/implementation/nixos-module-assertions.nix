# This must only be loaded on actual Nixos, otherwise `assertions`
# won't be defined when running `evaluateModules`.
{ config, ... }:
let cfg = config.satellite.dns;
in
{
  config.assertions =
    let assertProperToUsage = config:
      {
        assertion = (config.to == null) || (config.type == "CNAME");
        message = ''
          The option `satellite.dns.records[*].to` can only be used with `CNAME` records.
          This was not the case for ${config.type} record at ${config.at}.${config.zone}.
        '';
      };
    in builtins.map assertProperToUsage cfg.records;
}
