{ config, lib, ... }: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${config.stylix.image}" ];
      wallpaper = [ ",${config.stylix.image}" ] ++
        lib.forEach config.satellite.monitors ({ name, ... }:
          "${name},${config.stylix.image}"
        );
    };
  };
}
