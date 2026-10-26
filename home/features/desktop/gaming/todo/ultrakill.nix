{ config, ... }:
let
  persistentStateDir = config.satellite.persistence.at.state.bounds.source;
in
{
  satellite.games.entries.ultrakill = rec {
    name = "ULTRAKILL";
    developers = [ "Arsi \"Hakita\" Patala" ];
    release = "2020-09-03";
    description = ''
      ULTRAKILL is a fast-paced ultraviolent retro FPS combining the
      skill-based style scoring from character action games with
      unadulterated carnage inspired by the best shooters of the '90s. Rip
      apart your foes with varied destructive weapons and shower in their
      blood to regain your health. 
    '';

    # TODO: Handle the actual launching of the game :/
    file = "???";
    script = "umu";

    assets = {
      poster = ./assets/ultrakill/grid.jpg;
      logo = ./assets/ultrakill/logo.png;
      icon = ./assets/ultrakill/icon.jpg;
      background = ./assets/ultrakill/background.jpg;
    };
  };
}
