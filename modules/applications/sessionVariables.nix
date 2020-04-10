{ ... }:
with import ../../secrets.nix; {
  home-manager.users.adrielus.home.sessionVariables = {
    inherit GITHUB_TOKEN;
    GITHUB_USERNAME = "Mateiadrielrafael";
  };
}
