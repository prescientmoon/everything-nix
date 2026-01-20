{ config, ... }:
# hostapd creates a WiFi network my other devices can connect to
let
  interface = "wlo1";
in
{
  # We'll use the network card to create a network, not connect to one!
  satellite.wireless.enable = false;

  sops.secrets.wifi_password.sopsFile = ../secrets.yaml;
  services.hostapd = {
    enable = true;
    radios.${interface} = {
      band = "2g";
      countryCode = "NL";
      channel = 6; # ACS was taking too long each time 🤔
      # channel = 0; # Automatic channel selection

      networks.${interface} = {
        ssid = "five-pebbles";
        logLevel = 0; # Debugging
        authentication = {
          mode = "wpa2-sha256";
          wpaPasswordFile = config.sops.secrets.wifi_password.path;

          # This device doesn't support wpa3-sae :(
          # mode = "wpa3-sae";
          # saePasswords = [
          #   {
          #     password = "debug"; # DEBUG ONLY, will change later
          #   }
          # ];
        };

        settings = {
          bridge = "br0";

          # Having this on crashes the service for some reason...
          ieee80211w = 0;
        };
      };
    };
  };
}
