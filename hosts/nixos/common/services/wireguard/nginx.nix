# Nginx & DNS integration for my wireguard abstraction.
{ config, lib, ... }:
let
  wcfg = config.satellite.wireguard;
  ncfg = config.satellite.nginx;
  hostName = config.networking.hostName;

  mkAddresses =
    scope:
    let
      networkName = ncfg.address.${scope}.wgNetwork;
      network = wcfg.networks.${networkName};
      host = network.hosts.${hostName};
      isLeader = hostName == network.subnet.leader;
    in
    lib.mkIf (networkName != null) {
      satellite.nginx.address.${scope} = {
        v6 = lib.mkIf (network.prefix.v6 != null) host.address.v6;
        v4 = lib.mkIf (network.prefix.v4 != null) host.address.v4;
      };

      satellite.dns.records = lib.mkIf (network.prefix.v6 != null && isLeader) (
        lib.mapAttrsToList (name: host: {
          at = "${name}.${scope}";
          type = "AAAA";
          value = host.address.v6;
        }) network.hosts
      );
    };
in
{
  options.satellite.nginx = {
    address.overlay.wgNetwork = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    address.friends.wgNetwork = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf wcfg.enable (
    lib.mkMerge [
      (mkAddresses "overlay")
      (mkAddresses "friends")
    ]
  );
}
