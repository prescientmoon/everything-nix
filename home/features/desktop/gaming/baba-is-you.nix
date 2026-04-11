{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
in
{
  satellite.games.entries.baba-is-you = {
    name = "Baba Is You";
    developers = [ "Hempuli" ];
    release = "2019-03-10";
    description = ''
      Baba Is You is an award-winning puzzle game where you can change the
      rules by which you play. In every level, the rules themselves are
      present as blocks you can interact with; by manipulating them, you
      can change how the level works and cause surprising, unexpected
      interactions! With some simple block-pushing you can turn yourself
      into a rock, turn patches of grass into dangerously hot obstacles,
      and even change the goal you need to reach to something entirely
      different.
    '';

    file = "${persistentStateDir}/baba-is-you/itch-install/run.sh";
    script = "umu";

    assets = {
      poster = ./assets/baba-is-you/grid.jpg;
      logo = ./assets/baba-is-you/logo.png;
      icon = ./assets/baba-is-you/icon.jpg;
      background = ./assets/baba-is-you/background.jpg;
      screenshot = ./assets/baba-is-you/screenshot.jpg;
    };
  };

  satellite.persistence.at.state.apps.baba-is-you.directories = [
    {
      directory = "${config.xdg.dataHome}/Baba_Is_You";
      method = "symlink";
    }
  ];
}
