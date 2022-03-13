{ ... }:
with import ../../../secrets.nix;
let
  theme = "github-dark";
  variables = {
    # Configure github cli
    GITHUB_USERNAME = "Mateiadrielrafael";
    inherit GITHUB_TOKEN;

    # Sets neovim as default editor
    EDITOR = "nvim";
  };
in
{
  home-manager.users.adrielus = { home.sessionVariables = variables; };
}
