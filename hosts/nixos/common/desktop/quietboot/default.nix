{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.satellite.machine.graphical {
    boot.plymouth = {
      enable = true;
      theme = "cuts_alt";
      themePackages = [
        (import ./plymouth-themes.nix { inherit pkgs; }).cuts_alt
      ];
    };

    console = {
      useXkbConfig = true;
      earlySetup = false;
    };

    boot = {
      # See https://search.nixos.org/options?show=boot.initrd.verbose&query=boot.initrd.verbose
      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      consoleLogLevel = 0;
      initrd.verbose = false;
    };
  };
}
