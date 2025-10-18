{
  services.resolved.enable = false;
  services.dnsmasq = {
    enable = true;
    settings = {
      # upstream DNS servers
      server = [
        "9.9.9.9" # Quad9
        "8.8.8.8" # Google
        "1.1.1.1" # Cloudflare
      ];

      # sensible behaviours
      domain-needed = true;
      bogus-priv = true;
      no-resolv = true;

      # Cache DNS queries.
      cache-size = 1000;

      interface = "br1";
      dhcp-range = [ "br1,192.168.10.50,192.168.10.254,24h" ];
      dhcp-host = "192.168.10.1";

      # don't use /etc/hosts as this would advertise surfer as localhost
      no-hosts = true;
    };
  };
}
