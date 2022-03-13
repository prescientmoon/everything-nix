{ pkgs, ... }: {
  home-manager.users.adrielus = {
    xdg.configFile.wallpaper.source = pkgs.myThemes.current.wallpaper;
  };
}
