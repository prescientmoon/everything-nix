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

    # TODO: look into what this does
    extraConfig = ''
      update_config=1
    '';
  };

  # Ensure group exists
  users.groups.network = { };

  # Convenient alias for connecting to wifi
  environment.shellAliases.wifi = "sudo nmcli con up id";

  # Persist imperative config
  # environment.persistence = {
  #   "/persist".files = [
  #     "/etc/wpa_supplicant.conf"
  #   ];
  # };
}
