{ pkgs, ... }: {
  age.secrets.wakatime.file = ./wakatime_config.age;

  home = {
    file.".wakatime.cfg".source = config.age.secrets.wakatime.path;
    packages = with pkgs; [ wakatime ];
  };
}
