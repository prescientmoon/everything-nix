{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-hdd
    ./generated.nix
  ];

  # Do not suspend on lid closing
  services.logind.lidSwitch = "ignore";
}
