{ lib, config, ... }:
let
  cfg = config.satellite.postgres;
in
{
  # In a perfect world, this wouldn't be ON by default, but a lot of my services
  # depend on it being this way, and I'm too lazy to go around and make those
  # not live under this assumption.
  options.satellite.postgres = {
    enable = lib.mkEnableOption "satellite's postgres integration" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql.enable = true;
    environment.persistence."/persist/state".directories = [
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
      }
    ];
  };
}
