{ inputs, config, ... }:
let
  profile = "performance";
  # profile = "powersave";
in
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
  # }}}
  # {{{ Power management
  powerManagement.cpuFreqGovernor = profile;
  services.tlp = {
    enable = !config.services.desktopManager.plasma6.enable;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = profile;
      CPU_SCALING_GOVERNOR_ON_AC = profile;
    };
  };
  # }}}
}
