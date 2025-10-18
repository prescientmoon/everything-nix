# hostapd creates a WIFI network my other devices can connect to
let
  interface = "wlo1";
in
{
  services.hostapd = {
    enable = true;
    radios.${interface} = {
      band = "2g";
      countryCode = "NL";
      # channel = 0; # Automatic channel selection
      channel = 6;

      networks.${interface} = {
        ssid = "five-pebbles";
        logLevel = 0; # Debugging
        authentication = {
          # This device doesn't support wpa3-sae
          mode = "wpa2-sha1";
          wpaPassword = "debugdebug"; # DEBUG ONLY, will change later
        };

        settings = {
          bridge = "br0";
          ieee80211w = 0;
        };
      };
    };
  };
}
