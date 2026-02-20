# Sources:
# https://github.com/nickkjolsing/dockerMullvadVPN
# https://old.reddit.com/r/HomeServer/comments/xapl93/a_minimal_configuration_stepbystep_guide_to_media/
{ config, lib, ... }:
let
  port = config.satellite.ports.qbittorrent;
  dataDir = "/persist/data/media";
  configDir = "/persist/state/var/lib/qbittorrent";
  cfg = config.satellite.qbittorrent;
in
{
  options.satellite.qbittorrent = {
    enable = lib.mkEnableOption "satellite's qbittorrent integration";
  };

  config = lib.mkIf cfg.enable {
    satellite.containers.enable = true;

    # {{{ Networking & storage
    satellite.nginx.at."qbit.${config.networking.hostName}".port = port;
    sops.secrets.vpn_env.sopsFile = ../secrets.yaml;
    systemd.tmpfiles.rules = [
      "d ${dataDir} 777 ${config.users.users.pilot.name} users"
      "d ${configDir}"
    ];
    # }}}
    # {{{ Qbittorrent
    virtualisation.oci-containers.containers.qbittorrent = {
      image = "linuxserver/qbittorrent:5.1.2"; # 2025-11-02
      extraOptions = [ "--network=container:gluetun" ];
      dependsOn = [ "gluetun" ];
      volumes = [
        "${dataDir}:/downloads"
        "${configDir}:/config"
      ];

      environment = {
        WEBUI_PORT = toString port;
        PUID = toString config.users.users.pilot.uid;
        PGID = toString config.users.groups.users.gid;
        TZ = config.time.timeZone;
      };
    };
    # }}}
    # {{{ VPN
    virtualisation.oci-containers.containers.gluetun = {
      image = "qmcgaw/gluetun:v3.41"; # 2026-02-07
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
        VPN_SERVICE_PROVIDER = "mullvad";
        VPN_TYPE = "wireguard";
        UPDATER_PERIOD = "24h";
        KILL_SWITCH = "on"; # Turns off internet access if the VPN connection drops
      };
    };
    # }}}
  };
}
