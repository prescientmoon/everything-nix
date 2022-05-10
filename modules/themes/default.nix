{ ... }: {
  imports = [
    ./gtk.nix # Sets up gtk theming
    ./xresources.nix # Sets up xresources
    ./fonts.nix # Installs fonts and stuff (TODO: consider moving this into the individual themes which require these fonts?)
    ./wallpaper.nix # Sets the wallpaper required by the current theme
  ];
}
