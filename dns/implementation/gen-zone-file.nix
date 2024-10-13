{
  config,
  pkgs,
  lib ? pkgs.lib,
}:
let
  format = pkgs.formats.yaml { };
  cfg = config.satellite.dns;
  grouped = builtins.groupBy (entry: entry.zone) cfg.records;
  cpInvocations = lib.mapAttrsToList (
    zone: group:
    let
      grouped = builtins.groupBy (entry: entry.at) group;
      contents = lib.mapAttrs (
        at: entries:
        lib.lists.forEach entries (
          entry:
          let
            content =
              if builtins.typeOf entry.value == "list" then
                { values = entry.value; }
              else
                { inherit (entry) value; };
            cloudflare = if entry.enableCloudflareProxy then { octodns.cloudflare.proxied = true; } else { };
          in
          { inherit (entry) ttl type; } // content // cloudflare
        )
      ) grouped;
      file = format.generate "${zone}.yaml" contents;
    in
    "cp ${file} $out/${zone}.yaml"
  ) grouped;
in
pkgs.runCommand "octodns-zones" { } ''
  mkdir $out
  ${lib.concatStringsSep "\n" cpInvocations}
''
