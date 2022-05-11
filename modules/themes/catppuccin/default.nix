{ transparency ? 1, wallpaper }: { pkgs, ... }:
let
  githubTheme = pkgs.myVimPlugins.githubNvimTheme; # github theme for neovim
  variant = "dark";
  foreign = pkgs.callPackage (import ./foreign.nix) { };
in
{
  wallpaper = wallpaper.foreign or "${foreign.wallpapers}/${wallpaper}";

  name = "catppuccin";
  neovim = {
    plugins = [
      (
        pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "catppuccin";
          src = foreign.nvim;
        }
      )
    ];
    theme = builtins.readFile ./nvim.lua;

    lualineTheme = "catppuccin";
  };
  tmux.path = "${foreign.tmux}/catppuccin.conf";
  sddm.path = "${foreign.sddm}";
  grub.path = pkgs.nixos-grub2-theme;
  # grub.path = "${foreign.grub}/catppuccin-grub-theme/theme.txt";
  gtk.path = null;
  xresources = builtins.readFile "${foreign.xresources}/Xresources";
  rofi = {
    theme = "${foreign.rofi}/.local/share/rofi/themes/catppuccin.rasi";
    config = ''
      @import "${foreign.rofi}/.config/rofi/config.rasi"
      @import "${./rofi.rasi}"'';
  };
  alacritty.settings = {
    import = [ "${foreign.alacritty}/catppuccin.yml" ];
    window = {
      padding = {
        x = 0;
        y = 0;
      };

      gtk_theme_variant = "dark";
    };

    background_opacity = transparency;
  };
}

