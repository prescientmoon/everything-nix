{ config, ... }:
{
  sops.secrets.guacamole_users.sopsFile = ../../secrets.yaml;
  satellite.nginx.at.guacamole.port = config.satellite.ports.guacamole;

  virtualisation.oci-containers.containers.commafeed = {
    image = "";
    ports = [ "${toString config.satellite.nginx.at.guacamole.port}:8080" ];
    volumes = [
      "/etc/localtime:/etc/localtime"
      # "${config.sops.secrets.guacamole_users.path}:/etc/guacamole/user-mapping.xml"
      "/var/lib/guacamole:/config"
    ];

    environment = {
      TZ = config.time.timeZone;
    };
  };

  # Allow ssh-ing using the provided key
  users.users.pilot.openssh.authorizedKeys.keyFiles = [ ./ed25519.pub ];
}
