# Sources:
# https://github.com/nickkjolsing/dockerMullvadVPN
# https://www.reddit.com/r/HomeServer/comments/xapl93/a_minimal_configuration_stepbystep_guide_to_media/
{ config, pkgs, ... }:
let
  port = 8417;
  dataDir = "/persist/data/media";
  configDir = "/persist/state/var/lib/qbittorrent";
in
{
  imports = [ ../../common/optional/services/nginx.nix ];

  sops.secrets.vpn_env.sopsFile = ../secrets.yaml;

  services.nginx.virtualHosts."qbit.moonythm.dev" =
    config.satellite.proxy port { proxyWebsockets = true; };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 777 ${config.users.users.pilot.name} users"
    "d ${configDir}"
  ];

  # {{{ qbit
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
  # {{{ vpn
  virtualisation.oci-containers.containers.gluetun = {
    image = "qmcgaw/gluetun";
    extraOptions = [
      "--cap-add=net_admin"
      "--device=/dev/net/tun"
    ];

    ports = [ "${toString port}:${toString port}" ];
    environmentFiles = [ config.sops.secrets.vpn_env.path ];
    environment = {
      VPN_TYPE = "wireguard";
      VPN_SERVICE_PROVIDER = "mullvad";
      KILL_SWITCH = "on"; # Turns off internet access if the VPN connection drops
    };
  };
  # }}}
}
