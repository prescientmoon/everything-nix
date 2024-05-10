{ config, lib, ... }:
let
  port = 8418;
  host = "bin.moonythm.dev";
in
{
  imports = [ ./cloudflared.nix ];

  sops.secrets.microbin_env.sopsFile = ../secrets.yaml;

  services.cloudflared.tunnels =
    config.satellite.cloudflared.proxy host;
  services.nginx.virtualHosts.${host} =
    config.satellite.proxy port { } // { forceSSL = false; };

  services.microbin = {
    enable = true;
    dataDir = "/var/lib/microbin";
    passwordFile = config.sops.secrets.microbin_env.path;

    # {{{ Settings
    settings = {
      # High level settings
      MICROBIN_ADMIN_USERNAME = "prescientmoon";
      MICROBIN_PORT = toString port;
      MICROBIN_PUBLIC_PATH = "https://bin.moonythm.dev/";
      MICROBIN_DISABLE_TELEMETRY = "true";
      MICROBIN_DISABLE_UPDATE_CHECKING = "true";

      # Toggle certain features
      MICROBIN_READONLY = "true"; # Requires a password to upload
      MICROBIN_QR = "true"; # Allows generating qr codes
      MICROBIN_EDITABLE = "false";
      MICROBIN_HIGHLIGHTSYNTAX = "true";
      MICROBIN_SHOW_READ_STATS = "false";
      MICROBIN_ENABLE_BURN_AFTER = "false";
      MICROBIN_ENABLE_READONLY = "false";
      MICROBIN_ETERNAL_PASTA = "false";

      # Make UI more minimal
      MICROBIN_HIDE_FOOTER = "true";
      MICROBIN_HIDE_HEADER = "true";
      MICROBIN_HIDE_LOGO = "true";
    };
    # }}}
  };

  systemd.services.microbin.serviceConfig = {
    # We want to use systemd's `StateDirectory` mechanism to fix permissions
    ReadWritePaths = lib.mkForce [ ];
  };

  environment.persistence."/persist/state".directories = [ "/var/lib/private/microbin" ];
}
