{ config, pkgs, ... }:
let
  port = 8417;
  dataDir = "/persist/data/home/adrielus/media";
  configDir = "/persist/state/var/lib/qbittorrent";
  vpnConfigDir = "/persist/state/var/lib/openvpn";
in
{
  imports = [ ../../common/optional/services/nginx.nix ];

  services.nginx.virtualHosts."qbit.moonythm.dev" =
    config.satellite.proxy port { };

  systemd.tmpfiles.rules = [ "d ${dataDir}" "d ${configDir}" ];
  virtualisation.oci-containers.containers.qbittorrent = {
    image = "linuxserver/qbittorrent:latest";
    extraOptions = [ "--network=container:openvpn-client" ];
    dependsOn = [ "openvpn-client" ];
    volumes = [ "${dataDir}:/downloads" "${configDir}:/config" ];

    environment = {
      WEBUI_PORT = toString port;
    };
  };

  # {{{ open-vpn
  virtualisation.oci-containers.containers.openvpn-client = {
    image = "ghcr.io/wfg/openvpn-client";
    extraOptions = [
      "--network=bridge"
      "--cap-add=net_admin"
      "--device=/dev/net/tun"
    ];

    volumes = [ "${vpnConfigDir}:/data/vpn" ];
    ports = [ "${toString port}:${toString port}" ];

    environment = {
      KILL_SWITCH = "on"; # Turns off internet access if the VPN connection drops
    };
  };
  # }}}
}
