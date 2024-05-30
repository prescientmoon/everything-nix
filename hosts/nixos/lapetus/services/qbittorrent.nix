{ config, pkgs, ... }:
let
  port = 8417;
  dataDir = "/persist/data/media";
  configDir = "/persist/state/var/lib/qbittorrent";
in
{
  imports = [ ../../common/optional/services/nginx.nix ];

  services.nginx.virtualHosts."qbit.moonythm.dev" =
    config.satellite.proxy port { proxyWebsockets = true; };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 755 ${config.users.users.pilot.name} users"
    "d ${configDir} 755 ${config.users.users.pilot.name} users"
  ];

  virtualisation.oci-containers.containers.qbittorrent = {
    image = "trigus42/qbittorrentvpn";
    extraOptions = [
      "--cap-add=net_admin"
      "--sysctls=net.ipv4.conf.all.src_valid_mark=1,net.ipv6.conf.all.disable_ipv6=0"
    ];

    volumes = [
      "${dataDir}:/downloads"
      "${configDir}:/config/qBittorrent"
      "/persist/state/var/lib/mullvad/openvpn:/config/openvpn"
      "/persist/state/var/lib/mullvad/wireguard:/config/openvpn"
    ];

    ports = [ "${toString port}:8080" ];

    environment = {
      VPN_TYPE = "wireguard";
      TZ = "Europe/Amsterdam";
      PGID = "100";
      PUID = "1000";
    };
  };
}
