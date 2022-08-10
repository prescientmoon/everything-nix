{ transparency ? 1, wallpaper, variant }: { pkgs, lib, ... }:
let
  githubTheme = pkgs.myVimPlugins.githubNvimTheme; # github theme for neovim
  foreign = pkgs.callPackage (import ./foreign.nix) { };
  v = (a: b: if variant == "latte" then a else b);
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

  # grub.path = "${foreign.grub}/catppuccin-grub-theme/theme.txt";
  tmux.path = "${foreign.tmux}/catppuccin.conf";
  sddm.path = "${foreign.sddm}";
  grub.path = pkgs.nixos-grub2-theme;

  xresources = builtins.readFile "${foreign.xresources}/${variant}.Xresources";

  rofi = {
    themes = "${foreign.rofi}/.local/share/rofi/themes/";
    config = ''
      @import "${foreign.rofi}/.config/rofi/config.rasi"
      @theme "catppuccin-${variant}"
      @import "${./rofi.rasi}"
    '';
  };

  chromium.extensions = [
    # https://github.com/catppuccin/chrome
    (v
      "cmpdlhmnmjhihmcfnigoememnffkimlk"
      "bkkmolkhemgaeaeggcmfbghljjjoofoh")
  ];

  fish.dangerousColors = lib.strings.concatStringsSep " "
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
    ];

  alacritty.settings = {
    import = [ "${foreign.alacritty}/catppuccin.yml" ];
    # colors = "*${variant}";
    window = {
      padding = {
        x = 4;
        y = 4;
      };

      opacity = transparency;

      gtk_theme_variant = v "light" "dark";
    };

  };
}
