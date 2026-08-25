{ config, ... }:
{
  satellite.nginx.address.friends.wgNetwork = "direguard";
  satellite.wireguard.networks.direguard = {
    port = config.satellite.ports.wireguard-direguard;

    prefix.v4 = "10.10";
    prefix.v6 = "fd94:5eb4:040f";

    subnet.endpoint = "lapetus.public.${config.satellite.dns.domain}";
    subnet.leader = "lapetus";
    subnet.id = 1;

    # TODO: regen these?
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
