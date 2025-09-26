{
  # imports = [
  #   ../common/optional/services/wpa_supplicant.nix
  # ];

  users.users.pilot.extraGroups = [ "networkmanager" ];
  networking.networkmanager.enable = true;
  networking.useNetworkd = true;
  networking.interfaces.enp0s25.useDHCP = true;
}
