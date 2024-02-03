{ inputs, config, ... }:
let
  username = "prescientmoon";
  apiHost = "api.intray.moonythm.dev";
  apiPort = 8402;
  webHost = "intray.moonythm.dev";
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
    openFirewall = false;
    api-server = {
      enable = true;
      hosts = [ apiHost ];
      port = apiPort;
      admins = [ username ];
    };
    web-server = {
      enable = true;
      hosts = [ webHost ];
      port = webPort;
      api-url = "https://${apiHost}";
    };
  };
  # }}}
  # {{{ Networking & storage
  services.nginx.virtualHosts.${apiHost} = config.satellite.proxy apiPort { };
  services.nginx.virtualHosts.${webHost} = config.satellite.proxy webPort { };

  environment.persistence."/persist/state".directories = [
    "/www/intray/production/data"
  ];
  # }}}
}
