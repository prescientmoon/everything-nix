{
  imports = [
    ./global.nix

    ./features/desktop/gaming
    ./features/desktop/gaming/edopro.nix
    ./features/wayland/global.nix
    ./features/neovim
  ];

  home.stateVersion = "23.05";
  home.username = "moon";

  satellite = {
    dev.enable = true; # Enable symlinks outside the nix store
  };
}
