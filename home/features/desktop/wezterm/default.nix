{ inputs, pkgs, config, ... }: {
  # REASON: the unstable version crashes on launch
  home.packages = [ inputs.wezterm.packages.${pkgs.system}.default ];

  # Create link to config
  xdg.configFile."wezterm/colorscheme.lua".text = config.satellite.colorscheme.lua;
  xdg.configFile."wezterm/wezterm.lua".source =
    config.satellite.dev.path "home/features/desktop/wezterm/wezterm.lua";
}
