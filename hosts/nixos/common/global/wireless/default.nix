{ config, lib, ... }: {
  # Wireless secrets stored through agenix
  age.secrets.wireless.file = ./wifi_passwords.age;

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;

    # Declarative
    environmentFile = config.age.secrets.wireless.path;
    networks = {
      "Neptune".psk = "@PHONE_HOTSPOT_PASS@";
      "TP-Link_522C".psk = "@TG_HOME_PASS@";
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

  # Persist imperative config
  # environment.persistence = {
  #   "/persist".files = [
  #     "/etc/wpa_supplicant.conf"
  #   ];
  # };
}
