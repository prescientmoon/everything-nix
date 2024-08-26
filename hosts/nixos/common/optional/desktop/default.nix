{
  imports = [
    ../pipewire.nix
    ./xdg-portal.nix
  ];

  stylix.targets.gtk.enable = true;
}
