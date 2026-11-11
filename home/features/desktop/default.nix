{
  config,
  pkgs,
  upkgs,
  ...
}:
{
  imports = [
    ./discord
    ./elisa
    ./firefox
    ./gaming

    ./anyrun.nix
    ./foot.nix
    ./gimp.nix
    ./inlyne.nix
    ./mpv.nix
    ./obsidian.nix
    ./wlogout.nix
    ./wlsunset.nix
    ./zathura.nix
  ];

  # Notifies on low battery percentages
  services.batsignal.enable = true;

  # Use a base16 theme for gtk apps!
  stylix.targets.gtk.enable = true;
  gtk.enable = true;
  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus";
  };

  # The actual service is enabled by the NixOS module
  stylix.targets.dunst.enable = true;

  xdg.configFile.wallpaper.source = config.stylix.image;

  home.sessionVariables = {
    NIXOS_OZONES_WL = "1";

    # Bigger text in qt apps
    QT_SCREEN_SCALE_FACTORS = 1.4;

    # We technically don't want this on non TWMs, but I don't use any such WMs
    GTK_CSD = 0;
  }

  # Base packages
  home.packages =
    let
      _ = lib.getExe;
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";

      # {{{ OCR & QR scripts
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
        ${_ pkgs.libnotify} "Scanned QR code with output \"$(${wl-paste})\""
      '';
      # }}}
      # {{{ Screenshotting
      wl-ss-area = pkgs.writeShellScriptBin "wl-ss-area" ''
        set -euo pipefail # Fail on errors and whatnot
        filename="$(date --iso-8601=seconds).png"
        path="${config.xdg.userDirs.extraConfig.SCREENSHOTS}/$filename"
        ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" "$path"
        cat "$path" | ${wl-copy}
        ${_ pkgs.libnotify} "Successfully captured $filename"
      '';
      wl-ss-screen = pkgs.writeShellScriptBin "wl-ss-screen" ''
        set -euo pipefail # Fail on errors and whatnot
        filename="$(date --iso-8601=seconds).png"
        path="${config.xdg.userDirs.extraConfig.SCREENSHOTS}/$filename"
        ${_ pkgs.grim} "$path"
        cat "$path" | ${wl-copy}
        ${_ pkgs.libnotify} "Successfully captured $filename"
      '';
      # }}}
      # {{{ File uploader
      # Custom script for getting an URL to the contents of the clipboard
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
      anki # flashcards!
      aseprite # pixel art
      bitwarden-desktop # Password-manager
      dig # DNS queries
      element-desktop # Matrix client
      fluffychat # Matrix client
      gimp # Image editing
      gnome-calendar
      gnome-control-center # Required for configuring calendar accounts
      hyprpicker # Color picker
      imv # Image viewer
      karere # Whatsapp
      kdePackages.kdenlive # Video editor
      krita # drawing
      lagrange # Gemini browser
      libreoffice # document editing
      obs-studio # video recorder
      overskride # Bluetooth client
      qbittorrent # Torrent client
      sherlock # Search for usernames across different websites
      sqlite # I sometimes need to check the databases owned by various apps
      termdown # Basic CLI timer
      upkgs.freetube # YouTube client
      wl-clipboard # CLI for interacting with the clipboard
      wl-screenrec # video recorder (with daemon support!)
      yt-dlp # I often download live streams I can't watch in the moment
      (pkgs.callPackage ./vimclip.nix { })

      # NOTE: "expired" versions can no longer be used
      upkgs.signal-desktop # Signal client

      libnotify # Send notifications
      wl-tmp
      wl-ocr
      wl-qr
      wl-ss-area
      wl-ss-screen
    ];
}
