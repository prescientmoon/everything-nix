{
  pkgs,
  lib,
  config,
  ...
}:
{
  config.i18n.inputMethod = lib.mkIf config.satellite.machine.graphical {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc # for japanese input
      fcitx5-gtk
    ];
    fcitx5.waylandFrontend = true;
  };
}
