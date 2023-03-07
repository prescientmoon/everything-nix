{ pkgs, ... }:
{
  boot.plymouth = {
    enable = true;
    themePackages = [ pkgs.plymouthThemeCutsAlt ];
    theme = "cuts_alt";
  };

  boot = {
    # See https://search.nixos.org/options?show=boot.initrd.verbose&query=boot.initrd.verbose
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "vt.global_cursor_default=0"
      "udev.log_level=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
