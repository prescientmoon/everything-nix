{ config, ... }: {
  imports = [
    ../../common/optional/services/nginx.nix
    ../../common/optional/services/postgres.nix
  ];

  services.invidious = {
    enable = true;
    domain = "yt.moonythm.dev";
    port = 8414;

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

  services.nginx.virtualHosts.${config.services.invidious.domain} =
    config.satellite.proxy config.services.invidious.port { };
}
