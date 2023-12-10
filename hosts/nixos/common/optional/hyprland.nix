# The main configuration is specified by home-manager
{ inputs, pkgs, ... }: {
  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;
}
