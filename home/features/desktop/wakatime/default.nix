{ pkgs, config, ... }: {
  homeage.file.wakatime = {
    source = ./wakatime_config.age;
    symlinks = [
      "${config.home.homeDirectory}/.wakatime.cfg"
    ];
  };

  home.packages = with pkgs; [ wakatime ];
}
