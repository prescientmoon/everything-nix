{ config, ... }:
{
  sops.secrets.guacamoleUsers.sopsFile = ../../secrets.yaml;
  satellite.nginx.at.guacamole.port = 8443; # default tomcat port

  services.guacamole-server = {
    enable = true;
    services.guacamole-server.userMappingXml = config.sops.secrets.guacamoleUsers.path;
  };

  services.guacamole-client = {
    enable = true;
  };
}
