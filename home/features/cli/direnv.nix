{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.sessionVariables = {
    # No more long command warnings
    DIRENV_WARN_TIMEOUT = "24h";
    # No more usesless logs
    DIRENV_LOG_FORMAT = "";
  };
}
