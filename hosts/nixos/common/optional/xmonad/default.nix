{ pkgs, ... }:
let
  catpuccin-sddm = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    sha256 = "1lg10dyxgz080qfcp6k3zk6374jlj067s6p5fgx5r135ivy8mrki";
    rev = "bde6932e1ae0f8fdda76eff5c81ea8d3b7d653c0";
  };

  sddm-theme = "${catpuccin-sddm}/src/caputccin-latte";
in
{
  services.xserver = {
    enable = true;

    # Enable xmonad
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./Main.hs;
    };

    displayManager = {
      # make xmonad session the default
      defaultSession = "none+xmonad";

      # enable sddm
      # sddm = {
      #   enable = true;
      #   theme = sddm-theme;
      # };

      # enable startx
      startx.enable = true;

      # autoLogin = {
      #   enable = true;
      #   user = "adrielus";
      # };
    };
  };
}

