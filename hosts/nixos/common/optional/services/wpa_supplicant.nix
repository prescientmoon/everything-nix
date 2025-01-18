{ config, ... }:
{
  sops.secrets.wireless.sopsFile = ../../secrets.yaml;

  # https://github.com/NixOS/nixpkgs/blob/nixos-22.11/nixos/modules/services/networking/wpa_supplicant.nix
  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;

    # Declarative
    secretsFile = config.sops.secrets.wireless.path;
    networks = {
      "Neptune".pskRaw = "ext:ENCELADUS_HOTSPOT_PASS";

      "Familia-Matei-PRO".pskRaw = "ext:TG_HOTSPOT_HOME_PASS";
      "Familia-Matei".pskRaw = "ext:TG_HOTSPOT_HOME_PASS";

      "R15-5365 5g".pskRaw = "ext:TG_WIFI_HOME_PASS";
      "R15-5365".pskRaw = "ext:TG_WIFI_HOME_PASS";

      "Sailhorse".pskRaw = "ext:NL_PLACE_0_PASS";
      "Ziggo1721699".pskRaw = "ext:NL_PLACE_1_PASS";
      "Konijntjes".pskRaw = "ext:NL_PLACE_1_PODS_PASS";
      "InfoEdu12".pskRaw = "ext:INFOEDU_PASS";
      "CNU19".pskRaw = "ext:INFOEDU_PASS";
      "ZTE_F7A321".pskRaw = "ext:MADALINA_PASS";

      # [Working solution](https://bbs.archlinux.org/viewtopic.php?id=271336)
      # [Other interesting link](https://help.itc.rwth-aachen.de/en/service/b3d9a2c8ae5345b8b8f5128143ef4e3c/article/eaf6d69389a74a5a839c1f383c508df7/)
      # [Uni link](https://lwpwiki.webhosting.rug.nl/index.php/Configure_your_wifi_for_Eduroam)
      "eduroam" = {
        authProtocols = [ "WPA-EAP" ];
        auth = ''
          eap=PEAP
          identity="s5260329@rug.nl"
          password="ext:EDUROAM_PASS"
        '';
        extraConfig = ''
          phase2="auth=MSCHAPV2"
        '';
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
  };

  # Ensure group exists
  users.groups.network = { };

  # The service seems to fail if this file does not exist
  systemd.tmpfiles.rules = [ "f /etc/wpa_supplicant.conf" ];
}
