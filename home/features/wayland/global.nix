# Common wayland stuff
{ lib, pkgs, ... }:
{
  imports = [
    ../desktop

    ./wlsunset.nix
    ./wlogout.nix
    ./anyrun.nix
  ];

  home.sessionVariables.NIXOS_OZONES_WL = "1";
  services.swayosd.enable = true;

  home.packages =
    let
      _ = lib.getExe;
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";

      # {{{ OCR script
      # Taken from [here](https://github.com/fufexan/dotfiles/blob/3b0075fa7a5d38de13c8c32140c4b020b6b32761/home/wayland/default.nix#L14)
      wl-ocr = pkgs.writeShellScriptBin "wl-ocr" ''
        set -euo pipefail # Fail on errors and whatnot
        ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - \
          | ${_ pkgs.tesseract5} - - \
          | ${wl-copy}
        ${_ pkgs.libnotify} "Run ocr on area with output \"$(${wl-paste})\""
      '';

      wl-qr = pkgs.writeShellScriptBin "wl-qr" ''
        set -euo pipefail # Fail on errors and whatnot
        ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - \
          | ${pkgs.zbar}/bin/zbarimg --quiet - \
          | awk '{sub(/^QR-Code:/, "", $1); print $1}' \
          | ${wl-copy}
        ${_ pkgs.libnotify} "Scanned qr code on area with output \"$(${wl-paste})\""
      '';
      # }}}
      # {{{ File uploader
      wl-tmp = pkgs.writeShellScriptBin "wl-tmp" ''
        set -euo pipefail # Fail on errors and whatnot

        ext="$(${wl-paste} | file - --extension)"
        ext=''${ext#"/dev/stdin: "}
        if [ "$ext" = "???" ]; then
          ext="txt"
        fi

        name="$(date -u +"%y-%m-%d-%H-%M-%S").$ext"
        path="/tmp/$name"
        url="https://tmp.moonythm.dev/$name"

        ${wl-paste} > "$path"
        scp "$path" "root@lapetus.overlay.moonythm.dev:/persist/state/var/lib/tmp/$name"
        echo "$url" | ${wl-copy}

        ${_ pkgs.libnotify} "Uploaded file to $url"
      '';
      # }}}
    in
    with pkgs;
    [
      libnotify # Send notifications
      wl-ocr # Custom OCR script
      wl-qr # Custom qr scanner script
      wl-tmp # Custom script for getting an URL to the image in the clipboard
      wl-clipboard # Clipboard manager
      hyprpicker # Color picker
      grimblast # Screenshot tool
      wl-screenrec # video recorder (with daemon support!)
    ];
}
