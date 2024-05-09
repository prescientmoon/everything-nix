{ config, lib, ... }:
let port = 8418;
in
{
  imports = [ ./cloudflared.nix ];

  sops.secrets.microbin_env.sopsFile = ../secrets.yaml;
  services.cloudflared.tunnels =
    config.satellite.cloudflared.proxy "bin.moonythm.dev" port;

  services.microbin = {
    enable = true;
    dataDir = "/var/lib/microbin";
    passwordFile = config.sops.secrets.microbin_env.path;

    # {{{ Settings
    settings = {
      # High level settings
      MICROBIN_ADMIN_USERNAME = "prescientmoon";
      MICROBIN_PORT = toString port;
      MICROBIN_DISABLE_TELEMETRY = "true";

      # Toggle certain features
      MICROBIN_READONLY = "true"; # Requires a password to upload
      MICROBIN_QR = "true"; # Allows generating qr codes
      # MICROBIN_ETERNAL_PASTA = "true"; # Allows marking pastas to never be deleted

      # Make UI more minimal
      # MICROBIN_HIDE_FOOTER = "true";
      # MICROBIN_HIDE_HEADER = "true";
      # MICROBIN_HIDE_LOGO = "true";
    };
    # }}}
  };

  systemd.services.microbin.serviceConfig = {
    # We want to use systemd's `StateDirectory` mechanism to fix permissions
    ReadWritePaths = lib.mkForce [ ];
  };

  environment.persistence."/persist/state".directories = [ "/var/lib/private/microbin" ];
}
