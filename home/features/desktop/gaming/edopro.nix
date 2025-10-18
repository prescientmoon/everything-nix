# EDOPro is a fan-made Yu-Gi-Oh! simulator. This module produces a nix-ified
# version of the .desktop file EDOPro ships with.
#
# The game must be downloaded manually to `installPath`. As the game is not
# built with installing on an immutable file-system in mind, packaging the
# download using Nix feels a bit pointless.
#
# Download URL: https://projectignis.github.io/download.html
{
  config,
  lib,
  pkgs,
  ...
}:
let
  persistState = config.satellite.persistence.at.state.home;
  installPath = "${persistState}/yugioh/.local/share/edopro";
  launchScript = pkgs.writeShellScript "start-edopro" ''
    ${lib.getExe pkgs.steam-run} ${installPath}/EDOPro
  '';
in
{
  xdg.desktopEntries.edopro = {
    name = "EDOPro";
    type = "Application";
    comment = "The bleeding-edge automatic duel simulator";
    icon = "${installPath}/textures/AppIcon.png";
    categories = [ "Game" ];

    settings.StartupWMClass = "EDOPro";
    settings.Path = installPath;

    terminal = false;
    exec = builtins.toString launchScript;
  };
}
