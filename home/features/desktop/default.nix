{ pkgs, ... }: {
  imports = [
    ./wezterm # terminal
    ./dunst.nix # notifaction handler
  ];

  # Notifies on low battery percentages
  services.batsignal.enable = true;

  # Use a base16 theme for gtk apps!
  stylix.targets.gtk.enable = true;
  gtk.enable = true;

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus";
  };
}
