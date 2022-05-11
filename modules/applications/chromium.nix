{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;
  extensions = theme.chromium.extensions or [ ];
in
{
  home-manager.users.adrielus.programs.chromium = {
    enable = true;
    extensions = lib.lists.map (id: { inherit id; }) extensions;
  };
}
