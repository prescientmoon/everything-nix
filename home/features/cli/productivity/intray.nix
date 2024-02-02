{ config, ... }: {
  sops.secrets.intray_password.sopsFile = ./secrets.yaml;

  programs.intray = {
    enable = true;
    data-dir = "/persist/state/home/adrielus/intray";
    cache-dir = "/persist/local/cache/home/adrielus/intray";
    config.sync = "AlwaysSync";
    sync = {
      enable = true;
      username = "prescientmoon";
      password-file = config.sops.secrets.intray_password.path;
      url = "https://api.intray.moonythm.dev";
    };
  };
}
