# Sources:
# https://github.com/nickkjolsing/dockerMullvadVPN
# https://www.reddit.com/r/HomeServer/comments/xapl93/a_minimal_configuration_stepbystep_guide_to_media/
{ config, pkgs, ... }:
let
  port = 8417;
  dataDir = "/persist/data/media";
  configDir = "/persist/state/var/lib/qbittorrent";
  vpnConfig = "/persist/state/var/lib/mullvad/wireguard/ch-zrh-wg-001.conf";
in
{
  imports = [ ../../common/optional/services/nginx.nix ];

  services.nginx.virtualHosts."qbit.moonythm.dev" =
    config.satellite.proxy port { };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 755 ${config.users.users.pilot.name} users"
    "d ${configDir}"
  ];

  virtualisation.oci-containers.containers.qbittorrent = {
    image = "linuxserver/qbittorrent:latest";
    extraOptions = [ "--network=container:wireguard-client" ];
    dependsOn = [ "wireguard-client" ];
    volumes = [ "${dataDir}:/downloads" "${configDir}:/config" ];

    environment = {
      WEBUI_PORT = toString port;
    };
  };

  # {{{ wireguard-client
  virtualisation.oci-containers.containers.wireguard-client = {
    image = "ghcr.io/wfg/wireguard";
    extraOptions = [
      "--network=bridge"
      "--cap-add=net_admin"
      "--device=/dev/net/tun"
    ];

    volumes = [ "${vpnConfig}:/etc/wireguard/wg0.conf" ];
    ports = [ "${toString port}:${toString port}" ];

    environment = {
      KILL_SWITCH = "on"; # Turns off internet access if the VPN connection drops
    };
  };
  # }}}
}
