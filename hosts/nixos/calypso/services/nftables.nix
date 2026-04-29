{ config, ... }:
let
  overlay0Port = config.satellite.ports.wireguard-overlay;
in
{
  networking = {
    # No local firewall.
    nat.enable = false;
    firewall.enable = false;

    nftables = {
      enable = true;

      ruleset = ''
        table inet filter {
          set trusted_ifaces {
            type ifname;
            flags interval
            elements = { "lo", "docker0", "veth*", "overlay0" }
          }

          chain input {
            type filter hook input priority 0; policy drop;

            iifname @trusted_ifaces
              accept comment "Traffic from trusted interfaces";
            udp dport ${toString overlay0Port} accept \
              comment "Allow wireguard traffic";

            iifname "wlan0" ct state  { established, related } accept \
              comment "Allow established traffic";
            iifname "wlan0" icmp \
              type { echo-request, destination-unreachable, time-exceeded } \
              accept comment "Allow select ICMP";
            iifname "wlan0" ip6 nexthdr icmpv6 \
              accept comment "Allow select ICMPv6";
            iifname "wlan0" ip6 daddr fe80::/64 udp dport dhcpv6-client \
              accept comment "Allow DHCP6";
            iifname "wlan0" log prefix "WAN DROP:" counter drop \
              comment "Drop all other unsolicited traffic from wan";
          }

          chain forward {
            type filter hook forward priority filter; policy drop;

            iifname @trusted_ifaces oifname "wlan0" \
              accept comment "Allow trusted to WAN";
            iifname "wlan0" oifname @trusted_ifaces \
              ct state { established, related } \
              accept comment "Allow established from WAN back to trusted";
            iifname @trusted_ifaces oifname @trusted_ifaces \
              accept comment "Allow traffic between trusted interfaces";
          }

          chain output {
            type filter hook output priority 0; policy accept;
          }
        }
      '';
    };
  };

  # Not sure this is needed anymore, but Docker's management can be annoying...
  virtualisation.docker.daemon.settings.iptables = false;
}
