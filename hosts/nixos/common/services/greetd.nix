{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.satellite.greetd;
in
{
  options.satellite.greetd = {
    enable = lib.mkEnableOption "satellite's greetd integration" // {
      default = config.satellite.machine.graphical;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        message = "Greetd should only be used on graphical machines.";
        assertion = config.satellite.machine.graphical;
      }
    ];

    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = ''
            ${lib.getExe pkgs.tuigreet} \
              -g " (.>_>.) Welcome to ${config.networking.hostName}! (.<_<.)" \
              --user ${config.users.users.pilot.name} \
              --background doom \
              --remember-user-session \
              --remember \
              --asterisks \
              --debug
          '';
          user = "greeter";
        };
      };
    };

    satellite.persistence.at.cache.on."/var/cache".directories = [
      {
        base = "tuigreet";
        user = "greeter";
        group = "greeter";
      }
    ];
  };
}
