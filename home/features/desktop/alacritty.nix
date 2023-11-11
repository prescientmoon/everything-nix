{ config, lib, ... }:
{
  stylix.targets.alacritty.enable = true;

  programs.alacritty = {
    enable = true;

    settings = {
      window.opacity = lib.mkForce 0.5; # Conflicts with stylix
      window.padding = {
        x = 4;
        y = 4;
      };

      env = {
        TERM = "tmux-256color";
        ALWAYS_TMUX = 1;
      };

      working_directory = "${config.home.homeDirectory}/Projects/";
    };
  };
}
