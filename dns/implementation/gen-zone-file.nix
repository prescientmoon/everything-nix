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
        let
          grouped = builtins.groupBy (entry: entry.type) entries;
        in
        lib.mapAttrsToList (
          type: entries:
          let
            values = lib.lists.flatten (
              lib.lists.forEach entries (
                entry: if builtins.typeOf entry.value == "list" then entry.value else [ entry.value ]
              )
            );

            ttl = builtins.foldl' (ttl: entry: lib.trivial.max ttl entry.ttl) 0 entries;
            enableCloudflareProxy = builtins.foldl' (x: entry: x || entry.enableCloudflareProxy) false entries;
            cloudflare = if enableCloudflareProxy then { octodns.cloudflare.proxied = true; } else { };
            content =
              if builtins.length values == 1 then { value = builtins.elemAt values 0; } else { inherit values; };
          in
          { inherit ttl type; } // content // cloudflare
        ) grouped
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
