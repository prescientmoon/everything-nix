{ ... }:
with import ../../../secrets.nix;
let
  variables = {
    GITHUB_USERNAME = "Mateiadrielrafael";
    inherit GITHUB_TOKEN;
  };
in {
  home-manager.users.adrielus = {
    home.sessionVariables = variables;
    # programs.zsh.sessionVariables = variables;
  };
}
