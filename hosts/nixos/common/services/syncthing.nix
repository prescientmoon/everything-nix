{ config, lib, ... }:
let
  # Using `config.users.users.pilot.name` causes an infinite recursion error
  # due to the way the Syncthing module is written.
  user = config.satellite.pilot.name;
  group = "syncthing";
  dataDir = "/persist/state/var/lib/syncthing";
  cfg = config.satellite.syncthing;
in
{
  options.satellite.syncthing = {
    enable = lib.mkEnableOption "satellite's syncthing integration" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      inherit user group dataDir;
      enable = true;

      openDefaultPorts = true;
      configDir = "${dataDir}/config";

      overrideDevices = true;
      overrideFolders = true;

      settings = {
        # Device ids
        devices = {
          enceladus.id = "QWOAERM-V2FNXPI-TB7NFUS-LKW7JTB-IZY4OEZ-FYDPJNP-6IKPW4Y-YREXDQM";
          lapetus.id = "4YQV7GS-G2YGQD2-IXSLN6C-O2SDLOT-OZHSLF4-A3XTL6R-QCTZH4Z-F2A3KQK";
          tethys.id = "NGHX5G4-IY3ZXL2-NQMMRQV-2GDQLC6-LIDWSNG-DAJUAQH-KBAP64V-55K2LQ6";
          calypso.id = "B5ARPRC-DG3QYJA-BWSOMNO-57KG3BE-I3YUMXC-QEYVLH3-TNMC6XB-6LRSXAJ";
          chaldene.id = "VFHQY3U-VIH7BUA-Z77WWAW-WKHOSQI-6ZFKW3O-ZSGPLRU-2LTQ2FM-HKVBGQM";
        };

        extraOptions.options.crashReportingEnabled = false;
      };

      guiAddress = "127.0.0.1:${toString config.satellite.ports.syncthing}";
      settings.gui.insecureSkipHostcheck = true;
    };

    # Expose GUI interface via nginx
    satellite.nginx.at."syncthing.${config.networking.hostName}".port =
      config.satellite.ports.syncthing;

    # Syncthing seems to leak memory, so we want to restart it daily.
    systemd.services.syncthing.serviceConfig.RuntimeMaxSec = "1d";

    # Don't create default ~/Sync folder
    # See https://wrycode.com/reproducible-syncthing-deployments/
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    # I'm not sure this is needed anymore, I just know I got some ownership errors
    # at some point.
    systemd.tmpfiles.rules = [ "d ${dataDir} - ${user} ${group}" ];
  };
}
