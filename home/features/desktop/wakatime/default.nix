{ pkgs, config, ... }: {
  sops.secrets.wakatime_config = {
    sopsFile = ./secrets.yaml;
    path = "${config.home.homeDirectory}/.wakatime.cfg";
  };

  home.packages = [ pkgs.wakatime ];
}
