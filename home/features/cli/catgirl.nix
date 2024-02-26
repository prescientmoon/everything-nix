# Catgirl is a terminal based irc client
{ config, pkgs, lib, hostname ? "hermes", ... }:
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
  home.packages = [ ircgay pkgs.catgirl ];
  xdg.configFile."catgirl/tilde".text = mkCatgirlNetwork "tilde";
  satellite.persistence.at.state.apps.catgirl.directories =
    [ "${config.xdg.dataHome}/catgirl" ];
}
