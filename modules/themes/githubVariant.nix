{ variant, transparency ? 1, wallpaper }: { pkgs, ... }:
let
  githubTheme = pkgs.myVimPlugins.githubNvimTheme; # github theme for neovim
in
{
  inherit wallpaper;

  name = "github-${variant}";
  neovim = {
    plugins = [ pkgs.vimExtraPlugins.github-nvim-theme ];

    theme = ''
      require('github-theme').setup({theme_style = "${variant}", dark_float = true, transparent = true})
    '';

    lualineTheme = "github";
  };
  tmux.path = "${githubTheme}/terminal/tmux/github_${variant}.conf";
  sddm.path = "${pkgs.sddm-theme-chili}"; # TODO: don't expose this globally
  grub.path = pkgs.nixos-grub2-theme;
  rofi.config = ''@theme "purple"'';
  alacritty.settings = {
    import = [ "${githubTheme}/terminal/alacritty/github_${variant}.yml" ];
    window = {
      padding = {
        x = 8;
        y = 8;
      };

      gtk_theme_variant = if variant == "light" then "light" else "dark";
    };

    # transparent bg:)
    background_opacity = transparency;
  };
}

