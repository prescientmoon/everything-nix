{ pkgs, ... }:
let
  theme = pkgs.myThemes.current;
in
{
  home-manager.users.adrielus.xresources = {
    extraConfig = theme.xresources;
  };
}
