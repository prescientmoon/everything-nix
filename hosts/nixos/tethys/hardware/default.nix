{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-gpu-intel
    common-pc-laptop
    common-pc-ssd
    ./generated.nix
  ];
}
