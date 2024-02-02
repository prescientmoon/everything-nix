# Catgirl is a terminal based irc client
{ config, pkgs, hostname ? "hermes", ... }:
let
  mkCatgirlNetwork = network: ''
    host = ${network}.irc.moonythm.dev
    save = ${network}
    user = ${hostname}
    port = 6697
  '';
in
{
  satellite.persistence.at.state.apps.catgirl.directories = [ "${config.xdg.dataHome}/catgirl" ];
  home.packages = [ pkgs.catgirl ];
  xdg.configFile."catgirl/tilde".text = mkCatgirlNetwork "tilde";
}
