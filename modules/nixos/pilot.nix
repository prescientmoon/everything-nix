{ lib, ... }: {
  options.satellite.pilot = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "The name of the main user for this machine, as defined by `users.users.\${name}`";
    };
  };
}
