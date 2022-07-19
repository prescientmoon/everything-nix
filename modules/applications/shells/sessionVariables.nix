{ pkgs, ... }:
let
  theme = pkgs.myThemes.current;
  variables = {
    # Configure github cli
    GITHUB_USERNAME = "Mateiadrielrafael";

    # Sets neovim as default editor
    EDITOR = "nvim";
  };
in
{
  imports = [{
    home-manager.users.adrielus.home.sessionVariables = theme.env or { };
  }];

  home-manager.users.adrielus.home.sessionVariables = variables;
}
