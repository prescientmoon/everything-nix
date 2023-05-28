{ pkgs, inputs, ... }: {
  imports = [ ../default.nix ];

  home.packages = [ inputs.hyprland-contrib.packages.${pkgs.system}.grimblast ];

  wayland.windowManager.hyprland = {
    enable = true;
    recommendedEnvironment = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
