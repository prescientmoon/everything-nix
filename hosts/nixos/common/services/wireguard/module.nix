{ config, lib, ... }:
let
  cfg = config.satellite.wireguard;

  hostModule = networkName: network: args: {
    options = {
      subnet = lib.mkOption {
        type = lib.types.int;
        default = network.subnet.id;
        description = ''
          The subnet ID of the current machine. Defaults to the subnet ID
          defined in the parent network's config. Should only be set when
          describing other hubs that are part of the same network.
        '';
      };

      id = lib.mkOption {
        type = lib.types.int;
        description = ''
          The integer to be used as the last component of the machine's IP.
        '';
      };

      publicKey = lib.mkOption {
        type = lib.types.str;
        description = "The public key of the host's Wireguard instance.";
      };

      privateKeyFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          The private key of the host's Wireguard instance. Will only get
          evaluated on the target host. One can take advantage of said
          laziness by e.g. referencing sops/agenix secrets that only exist
          there.
        '';
        default = config.sops.secrets.${mkSecretName networkName}.path;
      };

      endpoint = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "The publicly-acessible endpoint for this foregin hub.";
        example = "example.com:666";
        default = null;
      };

      address.v4 = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        readOnly = true;
        default =
          if network.prefix.v4 == null then
            null
          else
            lib.concatStrings [
              network.prefix.v4
              ".${toString args.config.subnet}"
              ".${toString args.config.id}"
            ];
      };

      address.v6 = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        readOnly = true;
        default =
          if network.prefix.v6 == null then
            null
          else
            lib.concatStrings [
              network.prefix.v6
              ":${toString args.config.subnet}"
              "::${toString args.config.id}"
            ];
      };
    };
  };

  hostAsserts = network: name: host: [
    {
      assertion = (host.endpoint == null) == (network.subnet.id == host.subnet);
      message = ''
        Custom endpoint can (and must) only be specified for external hubs.
      '';
    }
    # NOTE: We could check for hostname / ID uniqueness, but I'm too lazy to :p
  ];

  networkModule =
    { config, name, ... }:
    {
      options = {
        port = lib.mkOption {
          type = lib.types.port;
          description = "The port hub should listen on.";
        };

        prefix.v4 = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "The /16 prefix to use for IPv4 routing.";
          example = "10.6";
          default = null;
        };

        prefix.v6 = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "The /48 prefix to use for IPv6 routing.";
          example = "fd9f:10e6:b842";
          default = null;
        };

        subnet.id = lib.mkOption {
          type = lib.types.int;
          example = 1;
        };

        subnet.leader = lib.mkOption {
          type = lib.types.str;
          description = "The hostname of the subnet's hub.";
        };

        subnet.endpoint = lib.mkOption {
          type = lib.types.str;
          description = "The publicly-acessible endpoint for the hub's leader.";
          example = "example.com";
        };

        hosts = lib.mkOption {
          type = with lib.types; attrsOf (submodule (hostModule name config));
          default = { };
          description = ''
            An attrset containing peers in the current network. This should
            contain a description of every hub in the network togerther with all
            the spokes attached to the current subnet's leader.
          '';
        };
      };
    };

  networkAsserts =
    name: network:
    [
      {
        assertion = (network.prefix.v4 != null) || (network.prefix.v6 != null);
        message = ''
          At least one routing prefix must be specified.
        '';
      }
      {
        assertion = network.hosts ? "${network.subnet.leader}";
        message = ''
          Missing host declaration for `satellite.wireguard.networks.${name}`'s
          leader (`${network.subnet.leader}`).
        '';
      }
    ]
    ++ lib.flatten (lib.mapAttrsToList (hostAsserts network) network.hosts);

  hostName = config.networking.hostName;
  mkNetworkConfig =
    name: network:
    let
      host = network.hosts.${hostName} or null;
      leader = network.hosts.${network.subnet.leader};

      hub = {
        PublicKey = leader.publicKey;
        Endpoint = "${network.subnet.endpoint}:${toString network.port}";
        PersistentKeepalive = 25; # 25 seconds
        AllowedIPs =
          with lib.lists;
          flatten [
            (optional (network.prefix.v6 != null) "${network.prefix.v6}::/48")
            (optional (network.prefix.v4 != null) "${network.prefix.v4}.0.0/16")
          ];
      };

      mkSpoke =
        peer:
        let
          foreign = peer.subnet != network.subnet.id;
        in
        {
          PublicKey = peer.publicKey;
          AllowedIPs =
            with lib.lists;
            flatten [
              (optional (network.prefix.v6 != null) # .
                "${peer.address.v6}/${if foreign then "64" else "128"}"
              )

              (optional (network.prefix.v4 != null) # .
                "${peer.address.v4}/${if foreign then "24" else "32"}"
              )
            ];
        }
        // (if peer.endpoint != null then { Endpoint = peer.endpoint; } else { });
    in
    lib.mkIf (host != null) {
      networks."50-${name}" = {
        matchConfig.Name = name;
        address =
          with lib.lists;
          flatten [
            (optional (network.prefix.v6 != null) "${host.address.v6}/128")
            (optional (network.prefix.v4 != null) "${host.address.v4}/32")
          ];
      };

      netdevs."50-${name}" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = name;
        };

        wireguardConfig = {
          ListenPort = network.port;
          PrivateKeyFile = "${host.privateKeyFile}";
          RouteTable = "main";
        };

        wireguardPeers =
          if hostName == network.subnet.leader then
            lib.pipe network.hosts [
              # Remove ourselves from the peer list
              (lib.filterAttrs (name: _: name != hostName))
              (lib.mapAttrsToList (_: mkSpoke))
            ]
          else
            [ hub ];
      };
    };

  mkSecretName = name: "wireguard_${name}_private_key";
  mkSecret =
    name: network:
    let
      host = network.hosts.${hostName} or null;
    in
    lib.mkIf (host != null) {
      ${mkSecretName name} = {
        sopsFile = ../../../${hostName}/secrets.yaml;
        mode = "640";
        owner = "systemd-network";
        group = "systemd-network";
      };
    };
in
{
  options.satellite.wireguard = {
    enable = lib.mkEnableOption "satellite's Wireguard integration" // {
      default = true;
    };

    networks = lib.mkOption {
      type = with lib.types; attrsOf (submodule networkModule);
      default = { };
      description = ''
        An attrset containing the various wireguard instances. Wireguard
        configuration will only be generated if the current machine's hostname
        matches any of the hosts in the network.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.flatten (lib.mapAttrsToList networkAsserts cfg.networks);

    # From the wiki: NixOS firewall will block wg traffic because (?)
    networking.firewall.checkReversePath = "loose";

    # In case the firewall is enabled
    networking.firewall.allowedUDPPorts = # .
      lib.mapAttrsToList # .
        (_: net: lib.mkIf (net.hosts ? "${hostName}") net.port)
        cfg.networks;

    sops.secrets = lib.mkMerge (lib.mapAttrsToList mkSecret cfg.networks);

    systemd.network = # .
      lib.mkMerge (lib.mapAttrsToList mkNetworkConfig cfg.networks);
  };
}
