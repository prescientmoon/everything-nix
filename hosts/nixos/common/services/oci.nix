{ lib, config, ... }:
let
  cfg = config.satellite.containers;
in
{
  options.satellite.containers = {
    enable = lib.mkEnableOption "satellite's OCI container integration" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };

    environment.persistence = {
      "/persist/state".directories = [ "/var/lib/containers/storage" ];
      "/persist/local/cache".directories = [ "/var/lib/containers/cache" ];
    };
  };
}
