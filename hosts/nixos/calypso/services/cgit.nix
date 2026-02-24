{ pkgs, config, ... }:
let
  host = "git.calypso";
in
{
  satellite.nginx.at.${host} = { };
  services.cgit."${config.satellite.nginx.at.${host}.host}" = {
    enable = true;
    package = pkgs.cgit-pink;
    scanPath = "/home/moon/projects/personal";
    group = "users";
    gitHttpBackend.enable = false; # I'll never clone local repos

    settings = {
      about-filter = "${pkgs.cgit-pink}/lib/cgit/filters/about-formatting.sh";
      commit-filter = "${pkgs.cgit-pink}/lib/cgit/filters/commit-links.sh";
      source-filter = "${pkgs.cgit-pink}/lib/cgit/filters/syntax-highlighting.py";
      enable-blame = true;
      enable-commit-graph = true;
      enable-follow-links = true;
      enable-log-filecount = false;
      enable-log-linecount = false;
      enable-remote-branches = false;
      enable-index-owner = false;
      robots = "nofollow";
      root-title = "moonythm.git";
      root-desc = "A silly little page for me to view my local repos :3";
      readme = "README.md";
      section-from-path = 0;
      remove-suffix = true;
    };
  };
}
