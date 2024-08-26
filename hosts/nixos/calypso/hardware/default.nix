{ inputs, ... }:
{
  # {{{ Imports
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-pc-laptop
    common-pc-ssd
    ./generated.nix
  ];
  # }}}
  # {{{ Misc
  hardware.enableAllFirmware = true;
  hardware.opengl.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.keyboard.qmk.enable = true;
  # }}}
  # {{{ Power management
  powerManagement.cpuFreqGovernor = "performance";
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "performance";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
    };
  };
  # }}}
}
