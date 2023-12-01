{ config, pkgs, lib, ... }: {
  home.packages = [ pkgs.hyprpaper ];
  services.hyprpaper = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    preload = [ config.stylix.image ];
    wallpapers = [{ inherit (config.stylix) image; }] ++
      lib.forEach config.satellite.monitors ({ name, ... }: {
        monitor = name;
        image = config.stylix.image;
      });
  };
}
