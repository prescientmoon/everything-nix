{ config, ... }:
{
  satellite.nginx.address.overlay.wgNetwork = "overlay0";
  satellite.wireguard.networks.overlay0 = {
    port = config.satellite.ports.wireguard-overlay;

    prefix.v4 = "10.21";
    prefix.v6 = "fd23:dc1a:69a6";

    subnet.endpoint = "lapetus.public.${config.satellite.dns.domain}";
    subnet.leader = "lapetus";
    subnet.id = 1;

    hosts.calypso = {
      id = 1;
      publicKey = "WEAwF03ZtrTmRx56ZOXmcpE/vFytPVVyZYwpr+bu9iA=";
    };

    hosts.lapetus = {
      id = 2;
      publicKey = "8d7CvIGhmLykF0MelaTEBVjus0L+VJnDQ4wQMv0V1Ds=";
    };

    hosts.tethys = {
      id = 3;
      publicKey = "5RG+Mi9JOuG/x+rN+1kVGbx/RUroHu5Lidjvu6CPvFM=";
    };

    hosts.chaldene = {
      id = 4;
      publicKey = "ezxZI/TVMSJ8+2Lmj6wfiiYIv2Dv5IkdI8ZxCM+JDxA=";
    };
  };
}
