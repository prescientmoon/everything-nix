{
  networking = {
    # No local firewall.
    nat.enable = false;
    firewall.enable = false;

    nftables = {
      enable = true;

      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy drop;

            iifname "lo"  accept comment "Accept everything from loopback interface"
            iifname "br0" accept comment "Allow local network to access the router"
            iifname "br1" accept comment "Allow local network to access the router"

            iifname "enp0s25" ct state  { established, related } accept comment "Allow established traffic"
            iifname "enp0s25" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"

            iifname "enp0s25" counter drop comment "Drop all other unsolicited traffic from wan"
          }

          chain forward {
            type filter hook forward priority filter; policy drop;

            iifname "br0" oifname "enp0s25" accept comment "Allow trusted LAN to WAN"
            iifname "br1" oifname "enp0s25" accept comment "Allow guest   LAN to WAN"
            iifname "enp0s25" oifname "br0" ct state { established, related } accept comment "Allow established back to LANs"
            iifname "enp0s25" oifname "br1" ct state { established, related } accept comment "Allow established back to LANs"
          }

          chain output {
            type filter hook output priority 0; policy accept;
          }
        }

        table ip nat {
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "enp0s25" masquerade
          }
        }
      '';
    };
  };

  # oifname "enp0s25" ip saddr 192.168.10.0/24 masquerade
}
