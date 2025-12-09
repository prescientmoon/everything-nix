{ lib, config, ... }:
let
  cfg = config.satellite.tailscale;
in
{
  options.satellite.tailscale = {
    enable = lib.mkEnableOption "satellite's tailscale integration" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.tailscale_auth_key.sopsFile = ../secrets.yaml;

    services.tailscale = {
      enable = true;
      useRoutingFeatures = lib.mkDefault "client";
      authKeyParameters.preauthorized = true;
      authKeyFile = config.sops.secrets.tailscale_auth_key.path;
      extraSetFlags = [
        "--accept-dns=false" # The DNS overriding breaks my setup
      ];
    };

    environment.persistence."/persist/state".directories = [
      "/var/lib/tailscale"
    ];
  };
}
