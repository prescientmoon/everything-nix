{ ... }:
with import ../../secrets.nix; {
  home-manager.users.brett.home.sessionVariables = {
    inherit GITHUB_TOKEN;
    GITHUB_USERNAME = "Mateiadrielrafael";
  };
}
