{ config, pkgs, ... }: {
  imports = [
    ../../common/optional/services/nginx.nix
    ../../common/optional/services/postgres.nix
  ];

  sops.secrets.invidious_hmac_key.sopsFile = ../secrets.yaml;
  sops.templates."invidious_hmac_key.json" = {
    content = ''{ "hmac_key": "${config.sops.placeholder.invidious_hmac_key}" }'';
    mode = "0444"; # I don't care about this key that much, as I'm the only user of this instance
  };

  services.nginx.virtualHosts.${config.services.invidious.domain} =
    config.satellite.proxy config.services.invidious.port { };

  services.invidious = {
    enable = true;
    domain = "yt.moonythm.dev";
    port = 8414;
    hmacKeyFile = config.sops.templates."invidious_hmac_key.json".path;

    nginx.enable = true;

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
    packages = pkgs.invidious.overrideAttrs (_oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "iv-org";
        repo = "invidious";
        fetchSubmodules = true;
        rev = "08390acd0c17875fddb84cabba54197a5b5740e4";
        sha256 = "sha256-75C/ImX/PYikVdSO4rZM/aYyEgx6pU90BHNeRFfcsDM=";
      };
    });
  };
}
