{ pkgs, ... }:
{
  boot.plymouth = {
    enable = true;
    themePackages = [ pkgs.plymouthThemeCutsAlt ];
    theme = "cuts_alt";
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
}
