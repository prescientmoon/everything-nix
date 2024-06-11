{ lib, ... }: {
  options.satellite.proxy = lib.mkOption {
    type = lib.types.functionTo (lib.types.functionTo lib.types.anything);
    description = "Helper function for generating a quick proxy config";
  };

  options.satellite.static = lib.mkOption {
    type = lib.types.functionTo lib.types.anything;
    description = "Helper function for generating a quick file serving config";
  };

  config.satellite.proxy = port: extra: {
    enableACME = true;
    acmeRoot = null;
    forceSSL = true;
    locations."/" = { proxyPass = "http://localhost:${toString port}"; } // extra;
  };

  config.satellite.static = root: {
    inherit root;
    enableACME = true;
    acmeRoot = null;
    forceSSL = true;
  };
}
