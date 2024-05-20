{ config, ... }: {
  sops.secrets.intray_password.sopsFile = ./secrets.yaml;

  programs.intray = {
    enable = true;
    data-dir = "${config.satellite.persistence.at.state.home}/intray";
    cache-dir = "${config.satellite.persistence.at.cache.home}/intray";
    config.sync = "AlwaysSync";
    sync = {
      enable = true;
      username = "prescientmoon";
      password-file = config.sops.secrets.intray_password.path;
      url = "https://api.intray.moonythm.dev";
    };
  };
}
