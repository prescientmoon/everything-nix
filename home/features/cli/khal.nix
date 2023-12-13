# TODO: sync theme with global theme
{ pkgs, ... }:
let calendarsHome = "productivity/calendars";
in
{
  home.packages = with pkgs; [ khal ];
  xdg.configFile."khal/config".text = ''
    [calendars]
      [[calendars]]
        path = ~/${calendarsHome}/*
        type = discover
        color = dark magenta

    [locale]
      timeformat = %H:%M
      dateformat = %d/%m/%Y

    [view]
      theme = light
  '';

  satellite.persistence.at.data.apps.khal.directories = [
    calendarsHome
  ];
}
