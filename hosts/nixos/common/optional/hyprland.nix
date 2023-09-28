{ inputs, pkgs, ... }: {

  programs.hyprland.enable = true;
  programs.hyprland.package =
    inputs.hyprland.packages.${pkgs.system}.hyprland;
}
