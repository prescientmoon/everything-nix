{ config, ... }: {
  programs.eww.enable = true;
  programs.eww.configDir = config.satellite-dev.path "home/adrielus/features/desktop/common/eww/widgets";
}
