{
  imports = [
    ./global.nix
    ./features/wayland/hyprland
  ];

  # Set up my custom imperanence wrapper
  satellite.persistence = {
    enable = true;

    # Actual data/media (eg: projects, images, videos, etc)
    at.data.path = "/persist/data";

    # App state I want to keep
    at.state.path = "/persist/state";

    # App state which I should be able to delete at any point
    at.cache.path = "/persist/cache";
  };
}
