{ inputs, config, ... }:
{
  # {{{ Imports
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-laptop
    common-pc-ssd
    asus-battery
    ./generated.nix
  ];
  # }}}
  # {{{ Misc
  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.keyboard.qmk.enable = true;
  # }}}
  # {{{ Power management
  powerManagement.cpuFreqGovernor = "performance";
  services.tlp = {
    enable = !config.services.desktopManager.plasma6.enable;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "performance";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
    };
  };
  # }}}
}
