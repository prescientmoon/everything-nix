{ config, lib, ... }:
let
  cfg = config.satellite.mullvad;
in
{
  options.satellite.mullvad = {
    enable = lib.mkEnableOption "satellite's mullvad integration";
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    networking.nftables = lib.mkIf config.satellite.tailscale.enable {
      enable = true;
      tables.mullvad_tailscale = {
        family = "inet";
        content = ''
          chain output {
            type route hook output priority -100; policy accept;
            ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
          }

          chain input {
            type filter hook input priority -100; policy accept;
            ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
          }
        '';
      };
    };
  };
}
