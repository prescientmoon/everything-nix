{ pkgs, ... }:
{
  # Allows typing `hostname` instead of `hostname.overlay.moonythm.dev`.
  # networking.search = [ "overlay.${config.satellite.dns.domain}" ];

  # Packages that are useful when debugging network issues. I'm install these
  # globally since the internet might be out when this happens.
  environment.systemPackages = [
    pkgs.nmap
    pkgs.dig # DNS queries
    pkgs.unixtools.arp
    pkgs.tcpdump
    pkgs.wireguard-tools
  ];

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  networking.useNetworkd = true;
  systemd.network.enable = true;

  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
}
