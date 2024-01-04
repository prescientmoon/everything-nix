{ ... }: {
  programs.waybar = {
    enable = false;

    systemd.enable = true;
    systemd.target = "hyprland-session.target";
  };

  stylix.targets.waybar = {
    enable = false;
  };
}
