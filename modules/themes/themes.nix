{ pkgs, lib, ... }:
let
  githubVariant = import ./githubVariant.nix;
  catppuccin = import ./catppuccin/default.nix;
in
lib.lists.map (theme: pkgs.callPackage theme { }) [
  (catppuccin {
    # wallpaper = "os/nix-magenta-pink-1920x1080.png";
    # wallpaper = "minimalistic/tetris.png";
    wallpaper = "os/nix-black-4k.png";
    # wallpaper = "misc/comfy-home.png";
    # wallpaper = "landscapes/forrest.png";
    # wallpaper = "landscapes/salty_mountains.png";
    # wallpaper = "misc/rainbow.png";
    # wallpaper.foreign = ./wallpapers/eye.png;
    # wallpaper.foreign = ./wallpapers/mountain.png;
    transparency = 0.93;
    variant = "macchiato";
  })
  (catppuccin {
    # wallpaper = "os/nix-magenta-pink-1920x1080.png";
    # wallpaper = "minimalistic/tetris.png";
    # wallpaper = "misc/comfy-home.png";
    # wallpaper = "landscapes/forrest.png";
    # wallpaper = "landscapes/salty_mountains.png";
    # wallpaper = "misc/rainbow.png";
    # wallpaper.foreign = ./wallpapers/eye.png;
    # wallpaper.foreign = ./wallpapers/mountain.png;
    wallpaper.foreign = ./wallpapers/rw_tower.png;
    transparency = 1;
    variant = "latte";
  })
  (githubVariant {
    variant = "light";
    # wallpaper = ./wallpapers/wall.png;
    wallpaper = ./wallpapers/synthwave.jpg;
    # wallpaper = ./wallpapers/eye.png;
    transparency = 0.8;
  })
  (githubVariant {
    variant = "dark";
    # wallpaper = ./wallpapers/synthwave.jpg;
    wallpaper = ./wallpapers/spaceship.jpg;
    transparency = 0.8;
  })
]
