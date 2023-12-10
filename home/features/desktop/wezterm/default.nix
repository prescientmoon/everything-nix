{ inputs, pkgs, config, ... }: {
  # REASON: the unstable version crashes on launch
  home.packages = [ inputs.wezterm.packages.${pkgs.system}.default ];

  xdg.configFile."wezterm/nix".source =
    config.satellite.lib.lua.writeFile
      "." "colorscheme"
      config.satellite.colorscheme.lua;
  xdg.configFile."wezterm/wezterm.lua".source =
    config.satellite.dev.path "home/features/desktop/wezterm/wezterm.lua";
}
