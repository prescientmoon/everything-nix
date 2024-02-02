{ inputs, config, ... }:
let
  username = "prescientmoon";
  apiHost = "api.intray.moonythm.dev";
  apiPort = 8402;
  webHost = "intray.moonythm.dev";
  webPort = 8403;
in
{
  # {{{ Import intray module 
  imports = [
    ../../common/optional/services/nginx.nix
    # We patch out the `intray` module to allow manual configuration for nginx
    (a:
      # NOTE: using `pkgs.system` before `module.options` is evaluated
      # leads to infinite recursion!
      let m = inputs.intray.nixosModules.x86_64-linux.default a;
      in
      {
        inherit (m) options;
        config = { inherit (m.config) systemd; };
      })
  ];
  # }}}
  # {{{ Configure intray 
  services.intray.production = {
    enable = true;
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
  services.nginx.virtualHosts.${apiHost} = config.satellite.proxy apiPort;
  services.nginx.virtualHosts.${webHost} = config.satellite.proxy webPort;

  environment.persistence."/persist/state".directories = [
    "/www/intray/production/data"
  ];
  # }}}
}
