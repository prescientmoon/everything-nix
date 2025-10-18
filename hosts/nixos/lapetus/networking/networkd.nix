# I use networkd as the primary way of configuring the network.
#
# I'm new to networking, so here's some notes:
# - the number in front of the keys specifies the ordering the configurations should be loaded in
# - bridges make multiple networks look like one from the exterior (?)
# - `linkConfig.RequiredForOnline` configures when the network should be considered "online"
# - `LinkLocalAddressing` allows enabling auto-allocation of IP addresses when DHCP is not there (???)
#
# These are the VLANs I currently use:
# - vlan10: used by the WIFI network this device induces
# - vlan20: private services accessible by me only
# - vlan30: public services accessible by the internet
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
      "20-vlan10" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan10";
        };

        vlanConfig.Id = 10;
      };

      "20-vlan20" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan20";
        };

        vlanConfig.Id = 20;
      };

      "20-vlan30" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan30";
        };

        vlanConfig.Id = 30;
      };

      "20-br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };

      "20-br1" = {
        netdevConfig = {
          Name = "br1";
          Kind = "bridge";
        };
      };
    };

    # Networks
    networks = {
      "30-enp0s25" = {
        matchConfig.Name = "enp0s25"; # This is the laptop's ethernet interface
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };

      "30-wlo1" = {
        matchConfig.Name = "wlo1"; # This is the laptop's wireless interface
        linkConfig.Unmanaged = "yes"; # hostapd will take care of this!
      };

      "40-br0" = {
        matchConfig.Name = "br0";
        linkConfig.RequiredForOnline = "carrier";
        networkConfig = {
          LinkLocalAddressing = "no";
          Address = "192.168.178.200/24";
          Gateway = "192.168.178.1";
        };

        vlan = [
          "vlan10"
          "vlan20"
          "vlan30"
        ];
      };

      "50-vlan20" = {
        matchConfig.Name = "vlan20";
        networkConfig = {
          Address = "192.168.20.1/24";
        };
      };

      "50-vlan30" = {
        matchConfig.Name = "vlan30";
        networkConfig = {
          Address = "192.168.30.1/24";
        };
      };

      "50-vlan10" = {
        matchConfig.Name = "vlan10";
        networkConfig.Bridge = "br1";
        linkConfig.RequiredForOnline = "enslaved";
      };

      "60-br1" = {
        matchConfig.Name = "br1";
        networkConfig = {
          Address = "192.168.10.1/24";
        };
      };
    };
  };
}
