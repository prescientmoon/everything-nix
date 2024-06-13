{ inputs, config, ... }:
let
  username = "prescientmoon";
  apiPort = config.satellite.ports.intray-api;
  webPort = config.satellite.ports.intray-client;
in
{
  imports = [ inputs.intray.nixosModules.x86_64-linux.default ];

  # {{{ Configure intray 
  services.intray.production = {
    enable = true;
    api-server = {
      enable = true;
      port = apiPort;
      admins = [ username ];
    };
    web-server = {
      enable = true;
      port = webPort;
      api-url = config.satellite.nginx.at."api.intray".url;
    };
  };
  # }}}
  # {{{ Networking & storage
  satellite.nginx.at."intray".port = webPort;
  satellite.nginx.at."api.intray".port = apiPort;

  environment.persistence."/persist/state".directories = [
    "/www/intray/production/data"
  ];
  # }}}
}
