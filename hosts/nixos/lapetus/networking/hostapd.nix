{ config, ... }:
# hostapd creates a WiFi network my other devices can connect to
let
  interface = "wlo1";
  bridge = "br0";
in
{
  # We'll use the network card to create a network, not connect to one!
  satellite.wireless.active = false;

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

          # This device doesn't support wpa3-sae :(
          wpaPasswordFile = config.sops.secrets.wifi_password.path;
        };

        settings = {
          inherit bridge;

          # Having this on crashes the service for some reason...
          ieee80211w = 0;
        };
      };
    };
  };

  networking.bridges.${bridge}.interfaces = [ ]; # Define the bridge
  networking.interfaces.${bridge}.ipv4.addresses = [
    # Devices in this WiFi network will have IPs of the form 192.168.10.X.
    # Addresses between 192.168.10.50 and 192.168.10.254 get leased to
    # clients for one day by dnsmasq.
    {
      address = "192.168.10.1";
      prefixLength = 24;
    }
  ];

  systemd.network.networks."30-${interface}" = {
    matchConfig.Name = interface;
    # Since hostapd takes care of this interface, we mark it as unmanaged.
    linkConfig.Unmanaged = "yes";
  };
}
