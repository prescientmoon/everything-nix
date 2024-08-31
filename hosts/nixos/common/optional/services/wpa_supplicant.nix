{ config, ... }:
{
  sops.secrets.wireless.sopsFile = ../../secrets.yaml;

  # https://github.com/NixOS/nixpkgs/blob/nixos-22.11/nixos/modules/services/networking/wpa_supplicant.nix
  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;

    # Declarative
    environmentFile = config.sops.secrets.wireless.path;
    networks = {
      "Neptune".psk = "@ENCELADUS_HOTSPOT_PASS@";

      "Familia-Matei-PRO".psk = "@TG_HOTSPOT_HOME_PASS@";
      "Familia-Matei".psk = "@TG_HOTSPOT_HOME_PASS@";

      "R15-5365 5g".psk = "@TG_WIFI_HOME_PASS@";
      "R15-5365".psk = "@TG_WIFI_HOME_PASS@";

      "Sailhorse".psk = "@NL_PLACE_0_PASS@";
      "Ziggo1721699".psk = "@NL_PLACE_1_PASS@";
      "Konijntjes".psk = "@NL_PLACE_1_PODS_PASS@";
      "InfoEdu12".psk = "@INFOEDU_PASS@";
      "CNU19".psk = "@INFOEDU_PASS@";
      "ZTE_F7A321".psk = "@MADALINA_PASS@";

      # [Working solution](https://bbs.archlinux.org/viewtopic.php?id=271336)
      # [Other interesting link](https://help.itc.rwth-aachen.de/en/service/b3d9a2c8ae5345b8b8f5128143ef4e3c/article/eaf6d69389a74a5a839c1f383c508df7/)
      # [Uni link](https://lwpwiki.webhosting.rug.nl/index.php/Configure_your_wifi_for_Eduroam)
      "eduroam" = {
        authProtocols = [ "WPA-EAP" ];
        auth = ''
          eap=PEAP
          identity="s5260329@rug.nl"
          password="@EDUROAM_PASS@"
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
