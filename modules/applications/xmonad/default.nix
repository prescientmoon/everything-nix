{ ... }: {
  home-manager.users.adrielus = {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };

    programs.rofi = {
      enable = true;
      font = "Source Code Pro 16";
      location = "center";
      padding = 10;
      lines = 7;
      fullscreen = false;
    };

    home.file.".config/plasma-workspace/env/set_window_manager.sh".text =
      "export KDEWM=/home/adrielus/.nix-profile/bin/xmonad";
  };
}
