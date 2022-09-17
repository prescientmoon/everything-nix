{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;
in
{
  imports = [
    {
      # Load theme
      home-manager.users.adrielus.programs.alacritty.settings = theme.alacritty.settings;
    }
  ];



  home-manager.users.adrielus = {
    xdg.configFile."alacritty/extraConfig.yml".text = theme.alacritty.extraConfig or "";
    programs.alacritty = {
      enable = true;

      settings = {
        import = [ "~/.config/alacritty/extraConfig.yml" ];

        window.decorations = "none";
        fonts.normal.family = "Nerd Font Source Code Pro";

        env = { TERM = "xterm-256color"; };
        working_directory = "/home/adrielus/Projects/";
      };
    };
  };
}
