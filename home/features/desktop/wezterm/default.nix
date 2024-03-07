{ inputs, upkgs, config, ... }: {
  home.packages = [ upkgs.wezterm ];

  xdg.configFile."wezterm/nix".source =
    config.satellite.lib.lua.writeFile
      "." "colorscheme"
      "return ${config.satellite.colorscheme.lua}";
  xdg.configFile."wezterm/wezterm.lua".source =
    config.satellite.dev.path "home/features/desktop/wezterm/wezterm.lua";
}
