{
  config,
  pkgs,
  lib,
  ...
}:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
  steamDir = "${config.xdg.dataHome}/Steam";
in
{
  satellite.games.entries.crypt-of-the-necrodancer = {
    name = "Crypt of the NecroDancer";
    developers = [
      "Brace Yourself Games"
      "Blitworks"
    ];
    release = "2015-04-23";
    description = ''
      Crypt of the NecroDancer is an award winning hardcore roguelike rhythm
      game. Move to the music and deliver beatdowns to the beat! Groove to the
      epic Danny Baranowsky soundtrack, or select songs from your own MP3
      collection! 
    '';

    file = "${persistentStateDir}/crypt-of-the-necrodancer/state/start.sh";
    script = "steam-run";

    assets = {
      poster = ./assets/crypt/grid.png;
      logo = ./assets/crypt/logo.png;
      icon = ./assets/crypt/icon.png;
      background = ./assets/crypt/background.png;
      screenshot = ./assets/crypt/screenshot.png;
    };
  };

  satellite.persistence.at.state.apps.crypt-of-the-necrodancer.directories = [
    {
      directory = "${config.xdg.dataHome}/NecroDancer";
      method = "symlink";
    }
    {
      directory = "${config.xdg.configHome}/NecroDancer";
      method = "symlink";
    }
  ];

  satellite.persistence.at.cache.apps.crypt-of-the-necrodancer.directories = [
    {
      directory = "${config.xdg.cacheHome}/NecroDancer";
      method = "symlink";
    }
  ];

  # This service is responsible for unpacking mods dowlnoaded from the Steam
  # workshop into the correct location the GOG version of the game can access.
  # TODO(2026-04-11): make this able to handle downloadable dungeons
  systemd.user.services.crypt-steam-importer = {
    Install.WantedBy = [ "default.target" ];
    Service.Restart = "on-failure";
    Service.ExecStart =
      let
        workshopContent = "${steamDir}/steamapps/workshop/content/247080";
        gameDir = "${persistentStateDir}/crypt-of-the-necrodancer/state/game/";
        cryptSteamImporter = pkgs.writeShellScript "crypt-steam-importer" ''
          set -euo pipefail # Fail on errors and whatnot
          for file in ${workshopContent}/*/*; do 
            if [ -f "$file" ]; then 
              ${lib.getExe pkgs.unzip} -u \
                "$file" "mods/*" \
                -d "${gameDir}"
            fi
          done
        '';
      in
      pkgs.writeShellScript "crypt-steam-importer-runner" ''
        set -euo pipefail # Fail on errors and whatnot
        ${lib.getExe pkgs.watchexec} \
          --watch "${workshopContent}" \
          ${cryptSteamImporter}
      '';
  };
}
