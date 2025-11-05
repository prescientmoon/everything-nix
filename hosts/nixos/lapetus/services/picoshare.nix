# Picoshare is a minimalist file sharing web application
# https://github.com/mtlynch/picoshare
{ config, ... }:
{
  satellite.cloudflared.at.share.port = config.satellite.ports.picoshare;

  sops = {
    secrets.picoshare_pass.sopsFile = ../secrets.yaml;
    templates."picoshare.env".content = ''
      PS_SHARED_SECRET=${config.sops.placeholder.picoshare_pass}
    '';
  };

  virtualisation.oci-containers.containers.picoshare = {
    image = "mtlynch/picoshare:1.5.1"; # 2025-08-24
    volumes = [ "/persist/state/var/lib/picoshare:/data" ];
    ports = [ "${toString config.satellite.ports.picoshare}:4001/tcp" ];
    environment.PORT = "4001";
    environmentFiles = [ config.sops.templates."picoshare.env".path ];
  };
}
