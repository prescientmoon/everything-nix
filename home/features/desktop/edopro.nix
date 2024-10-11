# EDOPro is a fanmade Yu-Gi-Oh! simulator.
# I am installing the game the traditional way, and
# adding a desktop entry which runs it via `steam-run`.
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
  # This is a nix-ified version of the .desktop file EDOPro comes with.
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
