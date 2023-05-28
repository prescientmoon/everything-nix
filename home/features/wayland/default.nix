# Common wayland stuff
{ lib, pkgs, upkgs, ... }: {

  imports = [
    ./wofi.nix
    ./dunst.nix
    ../desktop/wezterm # Default hyprland terminal
  ];

  # Makes some stuff run on wayland (?)
  # Taken from [here](https://github.com/fufexan/dotfiles/blob/3b0075fa7a5d38de13c8c32140c4b020b6b32761/home/wayland/default.nix#L14)
  # TODO: ask author what those do
  # home.sessionVariables = {
  #   QT_QPA_PLATFORM = "wayland";
  #   SDL_VIDEODRIVER = "wayland";
  #   XDG_SESSION_TYPE = "wayland";
  # };

  # TODO: set up
  # - wallpaper
  # - notification daemon
  # - screen recording
  # - volume/backlight controls
  # - eww bar
  # - configure hyprland colors using base16 stuff
  # - look into swaylock or whatever people use
  # - look into greetd or something
  # - multiple keyboard layouts

  home.packages =
    let
      _ = lib.getExe;

      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";

      # TODO: put this in it's own file perhaps?
      # Taken from [here](https://github.com/fufexan/dotfiles/blob/3b0075fa7a5d38de13c8c32140c4b020b6b32761/home/wayland/default.nix#L14)
      wl-ocr = pkgs.writeShellScriptBin "wl-ocr" ''
        ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - \
          | ${_ pkgs.tesseract5} - - \
          | ${wl-copy}
        ${_ pkgs.libnotify} "Run ocr on area with output \"$(${wl-paste})\""
      '';
    in
    with pkgs; [
      # Utils
      libnotify # Send notifications
      wl-ocr # Custom ocr script
      wl-clipboard # Clipboard manager
      wlogout # Nice logout script

      # REASON: not available on stable yet
      upkgs.hyprpicker # Color picker

      # Screenshot related tools
      grim # Take screenshot
      slurp # Area selector
    ];
}
