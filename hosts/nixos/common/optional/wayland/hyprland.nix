# The main configuration is specified by home-manager
{ pkgs, ... }: {
  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;
}
