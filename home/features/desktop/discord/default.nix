{ config, pkgs, ... }:
let
in
# themeMap = pkgs.callPackage (import ./themes.nix) { };
# REASON: newer discord versions don't work with the one in nixpkgs
# discocss = pkgs.discocss.overrideAttrs (old: rec {
#   version = "unstable-2023-09-02";
#   src = pkgs.fetchFromGitHub {
#     owner = "bddvlpr";
#     repo = "discocss";
#     rev = "37f1520bc90822b35e60baa9036df7a05f43fab8";
#     sha256 = "1559mxmc0ppl4jxvdzszphysp1j31k2hm93qv7yz87xn9j0z2m04";
#   };
# });
# vencord = pkgs.discord.override { withVencord = true; };
{
  programs.discord = {
    enable = true;
    disableUpdateCheck = true;
    enableDevtools = true;
    package = pkgs.vesktop;
  };

  # xdg.configFile."discocss/custom.css".source = config.satellite.theming.get themeMap;

  # {{{ Storage
  # Clean cache older than 10 days
  systemd.user.tmpfiles.rules = [ "d ${config.xdg.configHome}/discord/Cache/Cache_Data - - - 10d" ];

  satellite.persistence.at.state.apps.discord.directories = [
    "${config.xdg.configHome}/discord" # Why tf does discord store it's state here 💀
    "${config.xdg.configHome}/vesktop"
  ];
  # }}}
}
