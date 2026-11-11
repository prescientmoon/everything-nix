{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    # common-gpu-intel # This leads to a "prop ... defined twice" error
    common-pc-laptop
    common-pc-ssd
    ./generated.nix
  ];

  boot.kernelParams = [ "i915.enable_guc=2" ]; # Required by wl-screenrec for low power mode
  powerManagement.cpuFreqGovernor = "performance";
}
