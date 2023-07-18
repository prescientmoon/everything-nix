{ pkgs, ... }: {
  imports = [
    ./default.nix
    ../desktop
    ../desktop/alacritty.nix # Default xmonad terminal
  ];

  # Command required to get the xdg stuff to work. Suggested by @lily on discord.
  xsession.initExtra = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all";
}
