{ ... }:
with import ../../../secrets.nix;
let
  variables = {
    # Configure github cli
    GITHUB_USERNAME = "Mateiadrielrafael";
    inherit GITHUB_TOKEN;

    # Sets neovim as default editor
    EDITOR = "nvim";

    # Sets the current theme used by all programs
    THEME = "github-light";
  };
in
{
  home-manager.users.adrielus = { home.sessionVariables = variables; };
}
