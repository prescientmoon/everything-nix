{ config, ... }:
{
  sops.secrets.guacamole-users.sopsFile = ../../secrets.yaml;
  satellite.nginx.at.guacamole.port = 8443; # default tomcat port

  services.guacamole-server = {
    enable = true;
    userMappingXml = config.sops.secrets.guacamole-users.path;
  };

  services.guacamole-client = {
    enable = true;
  };

  # Allow ssh-ing using the provided key
  users.users.pilot.openssh.authorizedKeys.keyFiles = [ ./ed25519.pub ];
}
