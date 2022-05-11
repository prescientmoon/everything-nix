{ pkgs, ... }:
let
  theme = pkgs.myThemes.current;
in
{
  home-manager.users.adrielus.gtk = {
    enable = true;
    theme = theme.gtk.path or null;
  };
}
