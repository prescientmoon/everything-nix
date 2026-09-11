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
        # A table that runs on both IPv4 and IPv6
        table inet filter {
          # dnsmasq populates these with things to block
          set dnsmasq_blocked4        { type ipv4_addr; timeout 24h; }
          set dnsmasq_blocked6        { type ipv6_addr; timeout 24h; }
          set dnsmasq_mobile_blocked4 { type ipv4_addr; timeout 24h; }
          set dnsmasq_mobile_blocked6 { type ipv6_addr; timeout 24h; }

          # List of blessed devices that are known to not be smartphones.
          # These will be allowed to access things blocked by the last two sets
          # above.
          set not_mobile4 { # I don't have IPv6 set up for this yet!
            type ipv4_addr;

            # These must be in sync with dnmasq's static DHCP configuration 
            elements = {
              192.168.10.49 # calypso
            }
          }

          # Filters out http(s) traffic towards the dnsmasq_ipv{4,6} sets
          chain dns_filter {
            # This is overkill (blocks too much), but whatever :p
            ip  daddr @dnsmasq_blocked4 drop comment "Drop blocked domains";
            ip6 daddr @dnsmasq_blocked6 drop comment "Drop blocked domains";
            ip  daddr @dnsmasq_mobile_blocked4 ip saddr != @not_mobile4 drop \
              comment "Drop blocked non-mobile domains";
            ip6 daddr @dnsmasq_mobile_blocked6 drop \
              comment "Drop blocked non-mobile domains";
            accept;
          }

          # Things going towards this machine
          chain input {
            type filter hook input priority 0; policy drop;

            iifname "lo"  accept \
              comment "Accept everything from loopback interface";
            iifname "br0" accept \
              comment "Allow the local network to access the router";
            iifname {"docker0", "veth*"} accept \
              comment "Allow Docker to access the router";
            iifname "overlay0" accept \
              comment "Allow overlay network to access the router";

            udp dport ${toString overlay0Port} accept \
              comment "Allow wireguard traffic";

            iifname "enp0s25" tcp dport {80, 443} accept \
              comment "Allow HTTP(S) traffic";
            iifname "enp0s25" ct state  { established, related } accept \
              comment "Allow established traffic";
            iifname "enp0s25" icmp \
              type { echo-request, destination-unreachable, time-exceeded } \
              limit rate 10/second counter accept \
              comment "Allow select ICMP";
            iifname "enp0s25" ip6 nexthdr icmpv6 \
              limit rate 10/second counter accept \
              comment "Allow select ICMPv6";
            iifname "enp0s25" ip6 daddr fe80::/64 udp dport dhcpv6-client \
              accept comment "Allow DHCP6";
            iifname "enp0s25" log prefix "WAN DROP:" counter drop \
              comment "Drop all other unsolicited traffic from wan";
          }

          # Things going through this machine
          chain forward {
            type filter hook forward priority filter; policy drop;

            udp dport ${toString overlay0Port} accept \
              comment "Allow wireguard traffic";

            iifname "br0" oifname "enp0s25" jump dns_filter \
              comment "Allow LAN to WAN";
            iifname "enp0s25" oifname "br0" ct state { established, related } \
              accept comment "Allow established from WAN back to LAN";

            iifname "docker0" oifname "enp0s25" accept
              comment "Allow Docker to WAN";
            iifname "enp0s25" oifname "docker0" ct state { established, related } \
              accept comment "Allow established from WAN back to Docker";

            iifname "overlay0" oifname {"br0", "enp0s25"} accept \
              comment "Allow overlay to LAN/WAN";
            iifname {"br0", "enp0s25"} oifname "overlay0" \
              ct state { established, related } \
              accept comment "Allow established from LAN/WAN back to overlay";
            iifname "overlay0" oifname "overlay0" accept \
              comment "Allow overlay network traffic to pass through";
          }

          # Things going away from this machine
          chain output {
            type filter hook output priority 0; policy accept;
          }
        }

        table ip nat {
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;

            iifname {"docker0", "veth*", "br0"} oifname "enp0s25" \
              masquerade \
              comment "Mask all traffic going towards the ethernet interface";
          }
        }
      '';
    };
  };

  # Not sure this is needed anymore, but Docker's management can be annoying...
  virtualisation.docker.daemon.settings.iptables = false;
}
