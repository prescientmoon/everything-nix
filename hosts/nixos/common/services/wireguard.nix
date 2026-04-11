{ config, lib, ... }:
let
  inherit (config.networking) hostName;

  mkPeer = subnetId: interfaceId: pubKey: {
    inherit
      subnetId
      interfaceId
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
            network.routingPrefix.v6
            ":${toString host.subnetId}"
            "::${toString host.interfaceId}"
            "/128"
          ])
          (lib.concatStrings [
            network.routingPrefix.v4
            ".${toString host.subnetId}"
            ".${toString host.interfaceId}"
            "/32"
          ])
        ];

        # networkConfig = {
        #   IPv4Forwarding = true;
        #   IPv6Forwarding = true;
        # };
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
                id: peer:
                let
                  sameSubnet = peer.subnetId == network.subnetId;
                in
                {
                  PublicKey = peer.pubKey;
                  AllowedIPs = [
                    (lib.concatStrings [
                      network.routingPrefix.v6
                      ":${toString peer.subnetId}"
                      "::${toString peer.interfaceId}"
                      "/${if sameSubnet then "128" else "64"}"
                    ])
                    (lib.concatStrings [
                      network.routingPrefix.v4
                      ".${toString peer.subnetId}"
                      ".${toString peer.interfaceId}"
                      "/${if sameSubnet then "32" else "24"}"
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
                AllowedIPs = [
                  "${network.routingPrefix.v6}::/48"
                  "${network.routingPrefix.v4}.0.0/16"
                ];
                PersistentKeepalive = 25;
              }
            ];
      };

      # HACK
      satellite.nginx.overlayAddress.ipv6 = lib.mkIf (network.name == "overlay0") (
        lib.concatStrings [
          network.routingPrefix.v6
          ":${toString host.subnetId}"
          "::${toString host.interfaceId}"
        ]
      );

      satellite.nginx.overlayAddress.ipv4 = lib.mkIf (network.name == "overlay0") (
        lib.concatStrings [
          network.routingPrefix.v4
          ".${toString host.subnetId}"
          ".${toString host.interfaceId}"
        ]
      );

      satellite.dns.records = lib.mkIf (hostName == network.subnetLeader) (
        lib.mapAttrsToList (name: peer: {
          at = "${name}.${network.subdomain}";
          type = "AAAA";
          value = lib.concatStrings [
            network.routingPrefix.v6
            ":${toString peer.subnetId}"
            "::${toString peer.interfaceId}"
          ];
        }) network.hosts
        # ++ lib.mapAttrsToList (name: peer: {
        #   at = "${name}.${network.subdomain}";
        #   type = "A";
        #   value = lib.concatStrings [
        #     network.routingPrefix.v4
        #     ".${toString peer.subnetId}"
        #     ".${toString peer.interfaceId}"
        #   ];
        # }) network.hosts
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
      subdomain = "overlay";
      port = config.satellite.ports.wireguard-overlay;

      routingPrefix.v4 = "10.21";
      routingPrefix.v6 = "fd23:dc1a:69a6";
      subnetLeader = "lapetus";
      subnetId = 1;

      hosts = {
        calypso = mkPeer 1 1 "WEAwF03ZtrTmRx56ZOXmcpE/vFytPVVyZYwpr+bu9iA=";
        lapetus = mkPeer 1 2 "8d7CvIGhmLykF0MelaTEBVjus0L+VJnDQ4wQMv0V1Ds=";
        tethys = mkPeer 1 3 "5RG+Mi9JOuG/x+rN+1kVGbx/RUroHu5Lidjvu6CPvFM=";
        chaldene = mkPeer 1 4 "ezxZI/TVMSJ8+2Lmj6wfiiYIv2Dv5IkdI8ZxCM+JDxA=";
      };
    })
  ];
}
