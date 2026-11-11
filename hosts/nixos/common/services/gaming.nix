# Misc defaults for all gaming machines
{ config, lib, ... }:
{
  config = lib.mkIf config.satellite.machine.gaming {
    # Raise file limits (games often complain about this)
    boot.kernel.sysctl = {
      "fs.file-max" = 524288;
    };

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "65536";
      }
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
    ];

    # Toggle when connecting joycons, I guess
    services.joycond.enable = false;
    services.blueman.enable = false;
  };
}
