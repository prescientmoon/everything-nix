{ inputs, config, ... }:
let
  username = "prescientmoon";
  apiHost = "api.intray.moonythm.dev";
  apiPort = 8402;
  webPort = 8403;
in
{
  imports = [
    ../../common/optional/services/nginx.nix
    inputs.intray.nixosModules.x86_64-linux.default
  ];

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
      api-url = "https://${apiHost}";
    };
  };
  # }}}
  # {{{ Networking & storage
  services.nginx.virtualHosts.${apiHost} = config.satellite.proxy apiPort { };
  services.nginx.virtualHosts."intray.moonythm.dev" = config.satellite.proxy webPort { };

  environment.persistence."/persist/state".directories = [
    "/www/intray/production/data"
  ];
  # }}}
}
