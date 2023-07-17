{
  imports = [
    ../common/global
    ../common/users/adrielus.nix
    ../common/optional/slambda.nix

    ./hardware-configuration.nix
    ./boot.nix
  ];

  # Set the name of this machine!
  networking.hostName = "lapetus";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  # Boot
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
}
