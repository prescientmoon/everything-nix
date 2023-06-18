{ config, lib, pkgs, ... }: {
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "mjmsimuzc910khmr6yoccgtyr";
        device_name = "nix"; # TODO: perhaps include the hostname here?
        password_cmd =
          # TODO: move this in it's own module
          let identities = builtins.concatStringsSep " " (map (path: "-i ${path}") config.homeage.identityPaths);
          in "${lib.getExe pkgs.age} --decrypt ${identities} ${./password.age}";
      };
    };
  };
}

