{ config, ... }: {
  imports = [
    ../../common/optional/services/nginx.nix
    ../../common/optional/services/postgres.nix
  ];

  sops.secrets.invidious_hmac_key.sopsFile = ../secrets.yaml;
  services.nginx.virtualHosts.${config.services.invidious.domain} =
    config.satellite.proxy config.services.invidious.port { };

  services.invidious = {
    enable = true;
    domain = "yt.moonythm.dev";
    port = 8414;
    hmacKeyFile = config.sops.secrets.invidious_hmac_key.path;

    nginx.enable = true;

    settings = {
      captcha_enabled = false;
      admins = [ "prescientmoon" ];
      default_user_preferences = {
        default_home = "Subscriptions";
        max_results = 40;
        comments = [ "youtube" "reddit" ];
        save_player_pos = true;
        automatic_instance_redirect = true;
      };
    };
  };
}
