# Sources:
# https://github.com/nickkjolsing/dockerMullvadVPN
# https://www.reddit.com/r/HomeServer/comments/xapl93/a_minimal_configuration_stepbystep_guide_to_media/
{ config, pkgs, ... }:
let
  port = config.satellite.ports.qbittorrent;
  dataDir = "/persist/data/media";
  configDir = "/persist/state/var/lib/qbittorrent";
in
{
  # {{{ Networking & storage
  satellite.nginx.at.qbit.port = port;
  sops.secrets.vpn_env.sopsFile = ../secrets.yaml;
  systemd.tmpfiles.rules = [
    "d ${dataDir} 777 ${config.users.users.pilot.name} users"
    "d ${configDir}"
  ];
  # }}}
  # {{{ Qbit
  virtualisation.oci-containers.containers.qbittorrent = {
    image = "linuxserver/qbittorrent:latest";
    extraOptions = [ "--network=container:gluetun" ];
    dependsOn = [ "gluetun" ];
    volumes = [ "${dataDir}:/downloads" "${configDir}:/config" ];

    environment = {
      WEBUI_PORT = toString port;
      PGID = "100";
      PUID = "1000";
    };
  };
  # }}}
  # {{{ Vpn
  virtualisation.oci-containers.containers.gluetun = {
    image = "qmcgaw/gluetun";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=NET_RAW"
      "--device=/dev/net/tun"
      "--sysctl=net.ipv4.conf.all.forwarding=1"
    ];
    ports = [
      "${toString port}:${toString port}"
      "6881:6881"
      "6881:6881/udp"
    ];

    environmentFiles = [ config.sops.secrets.vpn_env.path ];
    environment = {
      VPN_TYPE = "openvpn";
      VPN_SERVICE_PROVIDER = "mullvad";
      KILL_SWITCH = "on"; # Turns off internet access if the VPN connection drops
    };
  };
  # }}}
}
