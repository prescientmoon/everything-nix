{ config, ... }:
let statePath = "${config.xdg.dataHome}/direnv/allow";
in
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.sessionVariables = {
    # No more long command warnings
    DIRENV_WARN_TIMEOUT = "24h";
    # No more usesless logs
    DIRENV_LOG_FORMAT = "";
  };

  # Only save allowed paths for 30d
  systemd.user.tmpfiles.rules = [ "d ${statePath} - - - 30d" ];
  satellite.persistence.at.state.apps.direnv.directories = [ statePath ];
}
