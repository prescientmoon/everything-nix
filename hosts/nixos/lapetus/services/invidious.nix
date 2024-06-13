{ config, pkgs, ... }: {
  sops.secrets.invidious_hmac_key.sopsFile = ../secrets.yaml;
  sops.templates."invidious_hmac_key.json" = {
    content = ''{ "hmac_key": "${config.sops.placeholder.invidious_hmac_key}" }'';
    mode = "0444"; # I don't care about this key that much, as I'm the only user of this instance
  };

  satellite.nginx.at.yt.port = config.satellite.ports.invidious;

  services.invidious = {
    enable = true;
    domain = config.satellite.nginx.at.yt.host;
    port = config.satellite.nginx.at.yt.port;
    hmacKeyFile = config.sops.templates."invidious_hmac_key.json".path;

    settings = {
      captcha_enabled = false;
      admins = [ "prescientmoon" ];
      default_user_preferences = {
        default_home = "Subscriptions";
        comments = [ "youtube" "reddit" ];
        save_player_pos = true;
        automatic_instance_redirect = true;
      };
    };

    # REASON: the current invidious is broken, and cannot play videos
    package = pkgs.invidious.overrideAttrs (_oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "iv-org";
        repo = "invidious";
        fetchSubmodules = true;
        rev = "eda7444ca46dbc3941205316baba8030fe0b2989";
        sha256 = "0iafxgb93jxx9ams6ll2yx8il4d7h89a630hcx9y8jj4gn3ax7v1";
      };
    });
  };
}
