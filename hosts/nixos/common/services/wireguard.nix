{ config, lib, ... }:
let
  inherit (config.networking) hostName;

  mkPeer = subnetId: interfaceId: prefixLength: pubKey: {
    inherit
      subnetId
      interfaceId
      prefixLength
      pubKey
      ; # Gotta love the formatter :|

    endpoint = null;
  };

  mkNetwork =
    network:
    let
      host = network.hosts.${hostName};
      secret = "wireguard_${network.name}_private_key";
    in
    lib.mkIf (network.hosts ? "${hostName}") {
      sops.secrets.${secret} = {
        sopsFile = ../../${hostName}/secrets.yaml;
        mode = "640";
        owner = "systemd-network";
        group = "systemd-network";
      };

      systemd.network.networks."50-${network.name}" = {
        matchConfig.Name = network.name;
        address = [
          (lib.concatStrings [
            network.routingPrefix
            ":${toString host.subnetId}"
            ":${host.interfaceId}"
            "/128"
          ])
        ];

        networkConfig = {
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };
      };

      networking.firewall.allowedUDPPorts = [ network.port ];

      systemd.network.netdevs."50-${network.name}" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = network.name;
        };

        wireguardConfig = {
          ListenPort = network.port;
          PrivateKeyFile = config.sops.secrets.${secret}.path;
          RouteTable = "main";
        };

        wireguardPeers =
          if hostName == network.subnetLeader then
            # Hub
            lib.pipe network.hosts [
              (lib.filterAttrs (id: _: id != hostName))
              (lib.mapAttrsToList (
                id: peer: {
                  PublicKey = peer.pubKey;
                  AllowedIPs = [
                    (lib.concatStrings [
                      network.routingPrefix
                      ":${toString peer.subnetId}"
                      ":${peer.interfaceId}"
                      "/${toString peer.prefixLength}"
                    ])
                  ];
                  Endpoint = lib.mkIf (peer.endpoint != null) peer.endpoint;
                }
              ))
            ]
          else
            # Spoke
            [
              {
                PublicKey = network.hosts.${network.subnetLeader}.pubKey;
                Endpoint = lib.concatStrings [
                  "${network.subnetLeader}"
                  ".public"
                  ".${config.satellite.dns.domain}"
                  ":${toString network.port}"
                ];
                AllowedIPs = [ "${network.routingPrefix}::/48" ];
                PersistentKeepalive = 25;
              }
            ];
      };

      # HACK
      satellite.nginx.overlayAddress.ipv6 = lib.mkIf (network.name == "overlay0") (
        lib.concatStrings [
          network.routingPrefix
          ":${toString host.subnetId}"
          ":${host.interfaceId}"
        ]
      );
    };
in
{
  config = lib.mkMerge [
    {
      # From the wiki: NixOS firewall will block wg traffic because of rpfilter (?)
      networking.firewall.checkReversePath = "loose";
    }

    (mkNetwork {
      name = "overlay0";
      port = config.satellite.ports.wireguard-overlay;

      routingPrefix = "fd23:dc1a:69a6";
      subnetLeader = "lapetus";
      subnetId = 1;

      hosts = {
        calypso = mkPeer 1 "0:0:0:1" 128 "WEAwF03ZtrTmRx56ZOXmcpE/vFytPVVyZYwpr+bu9iA=";
        lapetus = mkPeer 1 "0:0:0:2" 128 "8d7CvIGhmLykF0MelaTEBVjus0L+VJnDQ4wQMv0V1Ds=";
        tethys = mkPeer 1 "0:0:0:3" 128 "5RG+Mi9JOuG/x+rN+1kVGbx/RUroHu5Lidjvu6CPvFM=";
        chaldene = mkPeer 1 "0:0:0:4" 128 "ezxZI/TVMSJ8+2Lmj6wfiiYIv2Dv5IkdI8ZxCM+JDxA=";
      };
    })
  ];
}
