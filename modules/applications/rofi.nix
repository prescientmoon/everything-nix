{ ... }: {
  home-manager.users.adrielus.programs.rofi = {
    enable = true;
    font = "Source Code Pro 16";
    location = "center";
    padding = 10;
    lines = 7;
    fullscreen = false;
    cycle = true;
    theme = "solarized_alternate";
  };
}
