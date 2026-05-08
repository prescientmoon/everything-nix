{ pkgs, lib, ... }:
let
  gimp-clipboard = pkgs.writeShellScriptBin "gimp-clipboard" ''
    set -euo pipefail # Fail on errors and whatnot
    IMAGE_PATH="$(mktemp).png"
    wl-paste > "$IMAGE_PATH"
    notify-send "Saved edited picture from clipboard"
    ${lib.getExe pkgs.gimp} "$IMAGE_PATH"
    cat "$IMAGE_PATH" | wl-copy
    notify-send "Saved edited picture to clipboard"
  '';

  desktop-entry = pkgs.makeDesktopItem {
    name = "gimp-clipboard";
    desktopName = "GIMP clipboard";
    icon = "gimp";
    exec = lib.getExe gimp-clipboard;
  };
in
{
  home.packages = [
    gimp-clipboard
    desktop-entry
  ];
}
