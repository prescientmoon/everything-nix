{ pkgs, ... }: {
  home-manager.users.adrielus = {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };

    home.packages = with pkgs; [ xwallpaper ];

    # Tell KDE to use xmonad
    # home.file.".config/plasma-workspace/env/set_window_manager.sh".text =
    #  "export KDEWM=/home/adrielus/.nix-profile/bin/xmonad";

    services.picom = { enable = true; };
  };
}
