{
  users.users.pilot.extraGroups = [ "networkmanager" ];

  imports = [
    ./dnsmasq.nix
    ./hostapd.nix
    ./nftables.nix
  ];

  systemd.network.networks."60-enp0s25" = {
    matchConfig.Name = "enp0s25";
    address = [ "192.168.178.10/24" ];
    gateway = [ "192.168.178.1" ];
  };
}
