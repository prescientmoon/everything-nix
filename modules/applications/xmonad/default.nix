{ ... }: {
  home-manager.users.adrielus = {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };

    home.file.".config/plasma-workspace/env/set_window_manager.sh".text =
      "export KDEWM=/home/adrielus/.nix-profile/bin/xmonad";
  };

  # services.compton = {
  # enable = true;
  # activeOpacity = "0.8";
  # inactiveOpacity = "0.8";
  # fade = true;
  # shadow = true;
  # };
}
