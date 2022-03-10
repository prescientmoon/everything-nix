{ pkgs, lib, ... }:

let
  themes = pkgs.myThemes;

  createTheme = (theme: {
    xdg.configFile."alacritty/themes/${theme.name}.yml".text = builtins.toJSON
      (lib.attrs.recursiveUpdate theme.alacritty.settings {
        import = [ "~/.config/alacritty/alacritty.yml" ];
      });
  });

  createThemeConfigs = lib.lists.foldr
    (acc: theme: lib.attrs.recursiveUpdate acc (createTheme theme))
    { }
    themes;
in
{
  imports = [
    {
      home-manager.users.adrielus = createThemeConfigs;
    }
  ];

  home-manager.users.adrielus.programs.alacritty = {
    enable = true;

    settings = {
      window.decorations = "none";
      fonts.normal.family = "Nerd Font Source Code Pro";
    };
  };
}
