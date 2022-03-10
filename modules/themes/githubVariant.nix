variant: { pkgs, ... }: {
  name = "github-${variant}";
  neovim = {
    plugins = [
      pkgs.myVimPlugins.github-nvim-theme # github theme for neovim
    ];

    theme = ''
      require('github-theme').setup({theme_style = "light", dark_float = true, transparent = true})
    '';

    lualineTheme = "github";
  };
  tmux.path = "${pkgs.githubNvimTheme}/terminal/tmux/github_light.conf";
  alacritty.settings = {
    import = [ "${pkgs.githubNvimTheme}/terminal/alacritty/github_light.yml" ];
    window = {
      padding = {
        x = 8;
        y = 8;
      };

      # transparent bg:)
      background_opacity = 0.8;

      gtk_theme_variant = "light";
    };
  };
}
