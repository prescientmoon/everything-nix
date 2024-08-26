{ modulesPath, pkgs, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    ../common/global/services/openssh.nix
    ../common/global/locale.nix
    ../common/global/cli/fish.nix
    ../common/global/nix.nix
  ];

  environment.systemPackages = [ pkgs.neovim ];
}
