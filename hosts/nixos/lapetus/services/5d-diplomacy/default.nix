{ config, ... }:
{
  # Regenerate by going to the 5d-diplomacy directory and running:
  # nix run github:aksiksi/compose2nix -- \
  #   -project 5d-diplomacy \
  #   -runtime docker \
  #   -write_nix_setup=false \
  #   -build
  imports = [ ./generated.nix ];

  satellite.cloudflared.at.dip.port = config.satellite.ports."5d-diplomacy";

  virtualisation.oci-containers.containers."5d-diplomacy-frontend".ports = [
    "${toString config.satellite.ports."5d-diplomacy"}:8080"
  ];

  virtualisation.oci-containers.containers."5d-diplomacy-mssql".volumes =
    let
      dataDir = "/persist/state/var/lib/5d-diplomacy";
    in
    [
      "${dataDir}/mssql-data/data:/var/opt/mssql/data:rw"
      "${dataDir}/mssql-data/log:/var/opt/mssql/log:rw"
      "${dataDir}/mssql-data/secrets:/var/opt/mssql/secrets:rw"
    ];
}
