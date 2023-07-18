let
  user = "adrielus";
  group = "syncthing";
in
{
  services.syncthing = {
    inherit user group;
    enable = true;

    openDefaultPorts = true;

    configDir = "/persist/state/home/adrielus/Syncthing/.config/syncthing";
    dataDir = "/persist/data/syncthing";

    overrideDevices = true;
    overrideFolders = true;

    devices = {
      "enceladus" = { id = "QWOAERM-V2FNXPI-TB7NFUS-LKW7JTB-IZY4OEZ-FYDPJNP-6IKPW4Y-YREXDQM"; };
    };

    extraOptions = {
      options = {
        crashReportingEnabled = false;
      };
    };
  };
}
