{
  virtualisation.oci-containers.backend = "docker";

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  environment.persistence = {
    "/persist/state".directories = [ "/var/lib/containers/storage" ];
    "/persist/local/cache".directories = [ "/var/lib/containers/cache" ];
  };
}
