{
  pkgs,
  lib,
  ...
}:
let
  DOMAIN_LIST_REPO = pkgs.fetchFromGitHub {
    owner = "v2fly";
    repo = "domain-list-community";
    rev = "b064d988b474c21a7079cd2647a5cea0907298ac";
    sha256 = "0ff1lv8j3vhvaaqzdj110ss9znm77z8ki1vajzf90nkxyfk0k6gm";
  };

  # The script adds the domains of services like Reddit or YouTube to nftables
  # sets which can then be used to drop connections pointing to said services.
  #
  # See this article for details:
  # https://www.monotux.tech/posts/2024/08/dnsmasq-netfilter/
  #
  # Since services like YouTube own many domains, the repo below is used to
  # collect all the relevant names.
  #
  # This is likely not necessary in practice (blocking the IP addresses owned
  # by one is likely enough to cripple the service), but oh well...
  nftablesBlocklist = pkgs.runCommandLocal "dnsmasq-nftables-blocklist" {
    inherit DOMAIN_LIST_REPO;
  } "${lib.getExe pkgs.python3} ${./gen-dns-blocklist.py} > $out";
in
{
  services.resolved.enable = false;
  services.dnsmasq = {
    enable = true;
    settings = {
      # Upstream DNS servers
      server = [
        "9.9.9.9" # Quad9
        "8.8.8.8" # Google
        "1.1.1.1" # Cloudflare
      ];

      conf-file = [
        # Nix generates this using resolvconf, not super sure about the details
        "/etc/dnsmasq-conf.conf"

        # Automatically built by my python script (see above for details)!
        (toString nftablesBlocklist)
      ];

      # Sensible behaviours
      domain-needed = true;
      bogus-priv = true;
      no-resolv = true;

      # don't use /etc/hosts as this would advertise surfer as localhost
      no-hosts = true;

      # Cache DNS queries.
      cache-size = 1000;

      # DHCP server
      interface = "br0";
      dhcp-range = [ "br0,192.168.10.50,192.168.10.254,24h" ];
      dhcp-host = [
        "14:ac:60:56:be:97,192.168.10.49,static" # calypso
        "3c:f0:11:1a:b2:b5,192.168.10.48,static" # lapetus
      ];
    };
  };
}
