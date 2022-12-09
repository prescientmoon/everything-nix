{ transparency ? 1, wallpaper, variant }: { pkgs, lib, ... }:
let
  githubTheme = pkgs.myVimPlugins.githubNvimTheme; # github theme for neovim
  foreign = pkgs.callPackage (import ./foreign.nix) { };

  v = (a: b: if variant == "latte" then a else b);

  rofi-variant = "basic";
in
{
  name = "catppuccin-${variant}";
  wallpaper = wallpaper.foreign or "${foreign.wallpapers}/${wallpaper}";

  env = {
    CATPPUCCIN_FLAVOUR = variant;
  };

  neovim = {
    theme = ./nvim.lua;
    lualineTheme = "catppuccin";
  };

  tmux.path = "${foreign.tmux}/catppuccin-${variant}.conf";
  sddm.path = "${foreign.sddm}";

  xresources.config = builtins.readFile "${foreign.xresources}/${variant}.Xresources";

  rofi = {
    themes = "${foreign.rofi}/${rofi-variant}/.local/share/rofi/themes/";
    config = ''
      @import "${foreign.rofi}/${rofi-variant}/.config/rofi/config.rasi"
      @theme "catppuccin-${variant}"
      @import "${./rofi.rasi}"
    '';
  };

  fish.dangerousColors = lib.strings.concatStringsSep " "
    (v
      [
        "dc8a78"
        "dd7878"
        "ea76cb"
        "8839ef"
        "d20f39"
        "e64553"
        "fe640b"
        "df8e1d"
        "40a02b"
        "179299"
        "04a5e5"
      ]
      [
        "F2CDCD"
        "DDB6F2"
        "F5C2E7"
        "E8A2AF"
        "F28FAD"
        "F8BD96"
        "FAE3B0"
        "ABE9B3"
        "B5E8E0"
        "96CDFB"
        "89DCEB"
      ]);

  zathura = {
    enable = true;
    theme = "${foreign.zathura}/src/catppuccin-${variant}";
    name = "catppuccin-${variant}";
  };

  polybar.config = builtins.readFile "${foreign.polybar}/${variant}.ini";

  alacritty = {
    extraConfig = '' 
      ${builtins.readFile "${foreign.alacritty}/catppuccin.yml"}
      colors: *${variant}
    '';

    settings = {
      window = {
        padding = {
          x = 4;
          y = 4;
        };

        opacity = transparency;
      };
    };
  };
}
