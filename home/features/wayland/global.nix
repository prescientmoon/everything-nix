# Common wayland stuff
{ lib, pkgs, inputs, ... }: {
  imports = [
    ./wlsunset.nix
    ./wlogout.nix
    ./waybar.nix
    ./anyrun.nix

    ../desktop
    ../desktop/eww
  ];

  # TODO: set up
  # - volume/backlight controls
  # - bar
  # - configure hyprland colors using base16 stuff
  # - look into swaylock or whatever people use
  # - multiple keyboard layouts

  home.sessionVariables = {
    NIXOS_OZONES_WL = "1";
  };

  home.packages =
    let
      # {{{ OCR script
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

      wl-qr = pkgs.writeShellScriptBin "wl-qr" ''
        ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - \
          | ${pkgs.zbar}/bin/zbarimg --quiet - \
          | awk '{sub(/^QR-Code:/, "", $1); print $1}' \
          | ${wl-copy}
        ${_ pkgs.libnotify} "Scanned qr code on area with output \"$(${wl-paste})\""
      '';
      # }}}
    in
    with pkgs; [
      libnotify # Send notifications
      wl-ocr # Custom ocr script
      wl-qr # Custom qr scanner script
      wl-clipboard # Clipboard manager
      hyprpicker # Color picker
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast # Screenshot tool
    ];
}
