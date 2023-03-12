{ config, pkgs, ... }:
{
  stylix.targets.alacritty.enable = true;

  programs.alacritty = {
    enable = true;

    settings = {
      window.decorations = "none";
      window.padding = {
        x = 4;
        y = 4;
      };

      env = { TERM = "tmux-256color"; };
      working_directory = "${config.home.homeDirectory}/Projects/";
    };
  };
}
