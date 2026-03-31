{
  users.users.pilot.extraGroups = [ "networkmanager" ];

  imports = [
    ./dnsmasq.nix
    ./hostapd.nix
    ./nftables.nix
  ];
}
