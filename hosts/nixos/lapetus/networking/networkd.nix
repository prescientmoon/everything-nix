# I'm new to networking, so here's some notes:
# - the number in front of the keys specifies the ordering the configurations should be loaded in
# - bridges make multiple networks look like one from the exterior (?)
# - `linkConfig.RequiredForOnline` configures when the network should be considered "online"
# - `LinkLocalAddressing` allows enabling auto-allocation of IP addresses when DHCP is not there (???)
{
  # Forward packets (IPV4 only)
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = false;
  };

  # Useful for troubleshooting
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

  # We'll configure this manually per-interface
  networking.useDHCP = false;
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;

    # Do not require all the interfaces to be up
    wait-online.anyInterface = true;

    # Devices
    netdevs = {
      "20-br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };

    # Networks
    networks = {
      "30-enp0s25" = {
        # This is the laptop's ethernet interface
        matchConfig.Name = "enp0s25";
        linkConfig.RequiredForOnline = "carrier"; # I forgot what this meant :/

        networkConfig = {
          LinkLocalAddressing = "no";
          # This is our address to the router.
          # The /24 signifies the router's address space spans the last 8 bits.
          Address = "192.168.178.200/24";
          # This is "the router" (kinda), to us.
          Gateway = "192.168.178.1";
        };
      };

      "30-wlo1" = {
        # This is the laptop's wireless interface.
        matchConfig.Name = "wlo1";
        # Since hostapd takes care of this interface, we mark it as unmanaged.
        linkConfig.Unmanaged = "yes";
      };

      # This is the network where devices connecting to the WiFi network live.
      "40-br0" = {
        matchConfig.Name = "br0";
        linkConfig.RequiredForOnline = "no";

        # Devices in this WiFi network will have IPs of the form 192.168.10.X.
        # Addresses between 192.168.10.50 and 192.168.10.254 get leased to
        # clients for one day.
        address = [ "192.168.10.1/24" ];
      };
    };
  };
}
