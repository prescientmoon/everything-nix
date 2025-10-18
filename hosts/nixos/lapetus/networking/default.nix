{
  users.users.pilot.extraGroups = [ "networkmanager" ];

  imports = [
    ./dnsmasq.nix
    ./hostapd.nix
    ./networkd.nix
    ./nftables.nix
  ];
}
