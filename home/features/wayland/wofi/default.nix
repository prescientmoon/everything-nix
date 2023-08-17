{ config, ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      allow_markup = true;
      allow_images = true;
    };
  };

  xdg.configFile."wofi/style.css".source = config.satellite.dev.path "home/features/wayland/wofi/wofi.css";
}

