{ config, pkgs, ... }:
{
  # Allows typing `hostname` instead of `hostname.moonythm.dev`.
  networking.search = [ config.satellite.dns.domain ];

  # Packages that are useful when debugging network issues. I'm install these
  # globally since the internet might be out when this happens.
  environment.systemPackages = [
    pkgs.nmap
    pkgs.dig # DNS queries
    pkgs.unixtools.arp
  ];
}
