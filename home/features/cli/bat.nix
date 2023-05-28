{
  # Enabling this produces an uglier theme for some reason.
  # options.stylix.targets.bat.enable =true;
  programs.bat = {
    enable = true;
    config.theme = "base16-256";
  };
}
