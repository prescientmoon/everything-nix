{ config, pkgs, ... }:
let
  # Creates a .desktop file which launches a Steam game.
  mkSteamGame = name: id: {
    inherit name;
    type = "Application";
    categories = [ "Game" ];
    comment = "Launch ${name} on Steam";

    terminal = false;
    exec = "steam steam://rungameid/${id}";
    icon = "steam_icon_${id}";
  };
in
{
  home.packages = [
    pkgs.vvvvvv
    pkgs.lutris
  ];

  xdg.desktopEntries = {
    factorio = mkSteamGame "Factorio" "427520";
    noita = mkSteamGame "Noita" "881100";
    rainWorld = mkSteamGame "Rain World" "312520";
    slayTheSpire = mkSteamGame "Slay the Spire" "646570";
    ultrakill = mkSteamGame "ULTRAKILL" "1229490";
    voidStranger = mkSteamGame "Void Stranger" "2121980";
  };

  # {{{ Persistence
  satellite.persistence.at.state.apps.steam = {
    directories = [
      ".factorio"
      "${config.xdg.dataHome}/Steam"
      "${config.xdg.dataHome}/VVVVVV"
    ];
  };
  # }}}
}
