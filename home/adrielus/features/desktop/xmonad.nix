{ pkgs, ... }: {
  imports = [
    ./common/wezterm
    ./common/alacritty.nix
  ];

  # Other packages I want to install:
  home.packages = with pkgs; [
    vimclip # Vim anywhere!
  ];

  stylix.targets.gtk.enable = true;

  # Command required to get the xdg stuff to work. Suggested by @lily on discord.
  xsession.initExtra = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all";
}
