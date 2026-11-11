{ inputs, config, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    lenovo-ideapad-slim-5
    ./generated.nix
  ];

  hardware.enableAllFirmware = true;
}
