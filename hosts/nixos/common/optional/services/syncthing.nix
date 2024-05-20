{ config, ... }:
let
  # Using `config.users.users.pilot.name` causes an infinite recursion error
  # due to the way the syncthing module is written
  user = config.satellite.pilot.name;
  group = "syncthing";
  dataDir = "/persist/data/syncthing";
in
{
  services.syncthing = {
    inherit user group dataDir;
    enable = true;

    openDefaultPorts = true;
    configDir = "/persist/state/${config.users.users.pilot.home}/syncthing/.config/syncthing";

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      # {{{ Device ids 
      devices = {
        enceladus.id = "QWOAERM-V2FNXPI-TB7NFUS-LKW7JTB-IZY4OEZ-FYDPJNP-6IKPW4Y-YREXDQM";
        lapetus.id = "VVHM7RC-ZSDOZJI-EGBIJR4-2DOGAXG-OEJZWSH-OYUK5XT-7CDMWSL-3AVM2AZ";
        tethys.id = "NGHX5G4-IY3ZXL2-NQMMRQV-2GDQLC6-LIDWSNG-DAJUAQH-KBAP64V-55K2LQ6";
      };
      # }}}

      extraOptions.options.crashReportingEnabled = false;
    };
  };

  # Syncthing seems to leak memory, so we want to restart it daily.
  systemd.services.syncthing.serviceConfig.RuntimeMaxSec = "1d";

  # I'm not sure this is needed anymore, I just know I got some ownership errors at some point.
  systemd.tmpfiles.rules = [ "d ${dataDir} - ${user} ${group} -" ];
}
