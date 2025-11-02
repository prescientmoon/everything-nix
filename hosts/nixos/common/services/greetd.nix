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
      vt = 1; # NOTE: this will get removed in 25.11
      settings = {
        default_session = {
          command = ''
            ${lib.getExe pkgs.greetd.tuigreet} \
              -c ${lib.getExe config.programs.hyprland.package} \
              -g " (.>_>.) Welcome to ${config.networking.hostName}! (.<_<.)" \
              --remember
              --asterisks
          '';
          user = config.users.users.pilot.name;
        };
      };
    };
  };
}
