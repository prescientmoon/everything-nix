{ lib, config, ... }:
let
  port = config.satellite.ports.sqlite-web-historia;
in
{
  config = lib.mkIf config.satellite.machine.gaming {
    services.sqliteWeb.enable = true;
    services.sqliteWeb.databases.historia = {
      inherit port;
      user = config.users.users.pilot.name;
      file = "/persist/state/home/moon/historia/db.sqlite";
    };

    satellite.nginx.at."historia.${config.networking.hostName}".port = port;
  };
}
