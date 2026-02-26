# Catgirl is a terminal based irc client
{
  config,
  pkgs,
  spkgs,
  lib,
  hostname ? "hermes",
  ...
}:
let
  mkCatgirlNetwork = network: ''
    host = ${network}.irc.moonythm.dev
    save = ${network}
    user = ${hostname}
    port = 6697
  '';

  # prints an irc message in rainbow text
  ircgay = pkgs.writeShellScriptBin "ircgay" ''
    ${lib.getExe pkgs.toilet} -f term --irc --gay "$*"
  '';
in
{
  home.packages = [
    ircgay
    spkgs.catgirl
  ];

  xdg.configFile."catgirl/tilde".text = mkCatgirlNetwork "tilde";
  xdg.configFile."catgirl/libera".text = mkCatgirlNetwork "libera";
  xdg.configFile."catgirl/freenode".text = mkCatgirlNetwork "freenode";
  xdg.configFile."catgirl/hackint".text = mkCatgirlNetwork "hackint";
  xdg.configFile."catgirl/town".text = mkCatgirlNetwork "town";
  satellite.persistence.at.state.apps.catgirl.directories = [ "${config.xdg.dataHome}/catgirl" ];
}
