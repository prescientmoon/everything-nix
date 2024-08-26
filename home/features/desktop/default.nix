{ pkgs, ... }:
{
  imports = [
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

  # Bigger text in qt apps
  home.sessionVariables.QT_SCREEN_SCALE_FACTORS = 1.4;
}
