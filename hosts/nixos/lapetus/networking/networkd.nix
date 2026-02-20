{
  # Forward packets (IPV4 only)
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = false;
  };

  networking.useNetworkd = true;

  # Useful for troubleshooting
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
}
