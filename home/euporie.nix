{
  imports = [
    ./global.nix
    ./features/wayland/hyprland
  ];

  # Set up my custom imperanence wrapper
  satellite.persistence = {
    enable = true;
  };
}
