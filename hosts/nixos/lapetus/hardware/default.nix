{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-hdd
    common-pc-hdd
    ./generated.nix
  ];

  # Do not suspend on lid closing
  services.logind.lidSwitch = "ignore";
}
