{
  config,
  pkgs,
  upkgs,
  lib,
  ...
}:
let
  # Creates a .desktop file which launches a Steam game.
  mkSteamGame = name: id: icon: {
    inherit name icon;
    type = "Application";
    categories = [ "Game" ];
    comment = "Launch ${name} on Steam";

    terminal = false;
    exec = "steam steam://rungameid/${id}";
  };

  persistentStateDir = "/persist/state${config.home.homeDirectory}";
  steamDir = "${config.xdg.dataHome}/Steam";
  steamGameDir = "${steamDir}/steamapps/common";
  gameDir = "${config.home.homeDirectory}/media/games";
  heroicGameDir = "${gameDir}/heroic";
  heroicConfigDir = "${config.xdg.configHome}/heroic";
  heroicDataDir = "${config.xdg.dataHome}/heroic";

  historia = import ./historia { inherit pkgs; };
  historiaDbPath = "/persist/state/home/moon/historia/db.sqlite";

  mkUmuScript =
    {
      name,
      file,
      prefix ? "${persistentStateDir}/${name}/prefix",
    }:
    pkgs.writeShellScript "umu-${name}" ''
      PROTONPATH="${heroicConfigDir}/tools/proton/GE-Proton-latest" \
      WINEPREFIX="${prefix}" \
      ${historia}/bin/historia ${historiaDbPath} "${name}" \
        ${pkgs.umu-launcher}/bin/umu-run "${file}"
    '';

  mkSteamRunScript =
    {
      name,
      file,
    }:
    pkgs.writeShellScript "steam-run-${name}" ''
      cd "$(dirname "$(realpath "${file}")")"
      # NOTE: this doesn't work with `pkgs.steam-run`. 
      # This could be because I add additional packages in `steam.nix`?
      ${historia}/bin/historia ${historiaDbPath} "${name}" \
        steam-run "${file}"
    '';

  mkHistoriaScript =
    {
      name,
      file,
    }:
    pkgs.writeShellScript "historia-${name}" ''
      cd "$(dirname "$(realpath "${file}")")"
      ${historia}/bin/historia ${historiaDbPath} "${name}" "${file}"
    '';

  symlinkAll = lib.map (directory: {
    inherit directory;
    method = "symlink";
  });
in
{
  imports = [
    ./pegasus.nix
  ];

  # {{{ Desktop entries
  # TODO: download all of these icons locally
  xdg.desktopEntries = {
    factorio = mkSteamGame "Factorio" "427520" (
      pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/6ca4e9af5ea662a095c3243dc591bf54/32/256x256.png";
        sha256 = "04rl2k3yk0wf78xa98gigw5jb1vy35jx4cmh2vi7xc20sbg8hwca";
      }
    );

    noita = mkSteamGame "Noita" "881100" (
      pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/27b587bbe83aecf9a98c8fe6ab48cacc/32/256x256.png";
        sha256 = "1w745fz9aar86dpxj3hh6mmb22w8l3r7mvvgzr75g46p1xi3x5n8";
      }
    );

    rainWorld = mkSteamGame "Rain World" "312520" (
      pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/e53ba686b7ad2ec7825f0f4afff80a1b/32/256x256.png";
        sha256 = "181c9q1711g308aw4ap2n8phz5vc3x4favnnhdiyz47mm76d7zin";
      }
    );

    slayTheSpire = mkSteamGame "Slay the Spire" "646570" (
      pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/649634bc7ca601b5907341f5df39f0a4.png";
        sha256 = "0sp3fb41a68k9lb9s14j80780670kr9qic0pjiy2d2brvpw2m1d4";
      }
    );

    ultrakill = mkSteamGame "ULTRAKILL" "1229490" (
      pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/f40a635828e2bffd0a598a7ed621fc93.png";
        sha256 = "161xxp3psim92j00f5jd66wd05zxi3k7n66z24i30jg8ap92h246";
      }
    );

    voidStranger = mkSteamGame "Void Stranger" "2121980" (
      pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/2118fa0c24a3bee8842cc54a73775d9a.png";
        sha256 = "0b54p6vssjqjljji37qzhnaafxk8lwmzkw8i7vcfgd3m070arak9";
      }
    );

    silksong = mkSteamGame "Hollow Knight: Silksong" "1030300" (
      pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/f0e95622d20a747e93f5403e5193b155/32/256x256.png";
        sha256 = "1v3dpv37717mprd1qnxvghk3r1q05gd73pyj44s3ihxcwwyc86n3";
      }
    );
  };
  # }}}
  # {{{ Persistence
  satellite.persistence.at.state.apps = {
    wine.directories = [ ".wine" ];

    steam.directories = symlinkAll [
      steamDir

      # TODO(2025-12-16): move these to their own directories
      ".factorio"
      "${config.xdg.dataHome}/Baba_Is_You"
      "${config.xdg.configHome}/unity3d/Team Cherry"
    ];

    heroic.directories = symlinkAll [
      heroicConfigDir
      heroicGameDir

      # I store wine prefixes here (will try to move them out though)
      heroicDataDir
    ];

    # There might be more to cache in `.cache/lutris`, but this works for now
    lutris.directories = symlinkAll [
      "${config.xdg.configHome}/lutris" # General configuration data
      "${config.xdg.cacheHome}/lutris/banners" # Game banners
      "${config.xdg.cacheHome}/lutris/coverart" # Game cover art
      "${gameDir}/lutris"
    ];

    crypt-of-the-necrodancer.directories = symlinkAll [
      "${config.xdg.dataHome}/NecroDancer"
      "${config.xdg.configHome}/NecroDancer"
    ];

    vvvvvv.directories = symlinkAll [
      "${config.xdg.dataHome}/VVVVVV"
    ];
  };

  satellite.persistence.at.cache.apps = {
    umu.directories = symlinkAll [
      "${config.xdg.dataHome}/umu"
      "${config.xdg.cacheHome}/umu"
      "${config.xdg.cacheHome}/umu-protonfixes"
    ];

    crypt-of-the-necrodancer.directories = symlinkAll [
      "${config.xdg.cacheHome}/NecroDancer"
    ];
  };

  # TODO(2025-11-22): auto-convert Noita's GIFs to a better format
  # TODO(2025-12-16): move prefix to its own subdirectory
  systemd.user.tmpfiles.rules = [
    # Make Noita's GIFs more easily accessible
    "L+ ${config.xdg.userDirs.videos}/noita - - - - ${config.xdg.dataHome}/heroic/prefixes/default/Noita/drive_c/users/moon/AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots_animated/"
  ];
  # }}}

  programs.pegasus-frontend = {
    enable = true;
    collections.nix = {
      name = "Nix";
      shortname = "linux";
      # {{{ Noita
      games.noita = rec {
        name = "Noita";
        developers = [ "Nolla Games" ];
        release = "2020-10-15";
        description = "Noita is a magical action roguelite set in a world where every pixel is physically simulated. Fight, explore, melt, burn, freeze and evaporate your way through the procedurally generated world using spells you've created yourself.";

        file = "${heroicGameDir}/Noita/noita.exe";
        launch = mkUmuScript {
          inherit file;
          name = "noita";
          prefix = "${heroicDataDir}/prefixes/default/Noita";
        };

        assets = {
          poster = ./assets/noita/grid.png;
          logo = ./assets/noita/logo.png;
          icon = ./assets/noita/icon.png;
          background = ./assets/noita/background.png;
          screenshot = ./assets/noita/screenshot.jpg;
          # marquee = ./assets/noita/hero.png;
        };
      };
      # }}}
      # {{{ Crypt of the Necrodancer
      games.crypt-of-the-necrodancer = rec {
        name = "Crypt of the NecroDancer";
        developers = [
          "Brace Yourself Games"
          "Blitworks"
        ];
        release = "2015-04-23";
        description = "Crypt of the NecroDancer is an award winning hardcore roguelike rhythm game. Move to the music and deliver beatdowns to the beat! Groove to the epic Danny Baranowsky soundtrack, or select songs from your own MP3 collection!";

        file = "${persistentStateDir}/crypt-of-the-necrodancer/state/start.sh";
        launch = mkSteamRunScript {
          inherit file;
          name = "crypt-of-the-necrodancer";
        };

        assets = {
          poster = ./assets/crypt/grid.png;
          logo = ./assets/crypt/logo.png;
          icon = ./assets/crypt/icon.png;
          background = ./assets/crypt/background.png;
          screenshot = ./assets/crypt/screenshot.png;
        };
      };
      # }}}
      # {{{ Rain World
      games.rain-world = rec {
        name = "Rain World";
        developers = [
          "Videocult"
          "Akupara Games"
        ];
        release = "2017-03-28";
        description = "You are a nomadic slugcat, both predator and prey in a broken ecosystem. Grab your spear and brave the industrial wastes, hunting enough food to survive, but be wary— other, bigger creatures have the same plan... and slugcats look delicious.";

        file = "${steamGameDir}/Rain World/RainWorld.exe";
        launch = mkUmuScript {
          inherit file;
          name = "rain-world";
        };

        assets = {
          poster = ./assets/rain-world/grid.png;
          logo = ./assets/rain-world/logo.png;
          icon = ./assets/rain-world/icon.png;
          background = ./assets/rain-world/background.png;
          screenshot = ./assets/rain-world/screenshot.png;
        };
      };
      # }}}
      # {{{ VVVVVV
      games.vvvvvv = rec {
        name = "VVVVVV";
        developers = [ "Terry Cavanagh" ];
        release = "2010-09-08";
        description = "VVVVVV is a platform game all about exploring one simple mechanical idea - what if you reversed gravity instead of jumping?";

        file = "${pkgs.vvvvvv}/bin/vvvvvv";
        launch = mkHistoriaScript {
          inherit file;
          name = "vvvvvv";
        };

        assets = {
          poster = ./assets/vvvvvv/grid.png;
          logo = ./assets/vvvvvv/logo.png;
          icon = ./assets/vvvvvv/icon.png;
          background = ./assets/vvvvvv/background.png;
          screenshot = ./assets/vvvvvv/screenshot.jpg;
        };
      };
      # }}}
      # {{{ EDOPro
      games.edopro = rec {
        name = "EDOPro";
        developers = [ "Project Ignis team" ];
        description = "EDOPro is an automatic Yu-Gi-Oh! dueling simulator.";

        file = "${persistentStateDir}/yugioh/.local/share/edopro/EDOPro";
        launch = mkSteamRunScript {
          inherit file;
          name = "edopro";
        };

        assets = {
          poster = ./assets/edopro/grid.png;
          logo = ./assets/edopro/logo.png;
          icon = ./assets/edopro/icon.png;
          background = ./assets/edopro/background.png;
          screenshot = ./assets/edopro/screenshot.png;
        };
      };
      # }}}
      # {{{ Steins;Gate
      games.steins-gate = rec {
        name = "Steins;Gate";
        developers = [ "MAGES" ];
        release = "2009-10-15";
        description = "
          -Decide The Fate Of All Mankind-\\n
          CAN YOU CHANGE THE COURSE OF FATE?\\n
          AND SAVE THE ONES CLOSEST TO YOU?\\n
        ";

        # The files I have from my Steam copy do not work by themselves, but a
        # bit of patching solved the issue.
        file = "${persistentStateDir}/science-adventure/steins-gate/steam-install/Launcher.exe";
        launch = mkUmuScript {
          inherit file;
          name = "steins-gate";
          prefix = "${persistentStateDir}/science-adventure/steins-gate/prefix";
        };

        assets = {
          poster = ./assets/steins-gate/grid.png;
          logo = ./assets/steins-gate/logo.png;
          icon = ./assets/steins-gate/icon.png;
          background = ./assets/steins-gate/background.jpg;
          screenshot = ./assets/steins-gate/screenshot.jpg;
        };
      };
      # }}}
      # {{{ Braid
      games.braid = rec {
        name = "Braid";
        developers = [ "Number None" ];
        release = "2008-08-06";
        description = "
          Control the flow of time to solve puzzles in this new version of the 
          indie classic, featuring fully repainted artwork, a new world of 
          puzzles, and seriously in-depth commentary.
        ";

        file = "${persistentStateDir}/braid/steam-install/braid64_d3d11_final.exe";
        launch = mkUmuScript {
          inherit file;
          name = "braid";
        };

        assets = {
          poster = ./assets/braid/grid.png;
          logo = ./assets/braid/logo.png;
          icon = ./assets/braid/icon.png;
          background = ./assets/braid/background.jpg;
          screenshot = ./assets/braid/screenshot.jpg;
        };
      };
      # }}}
      # {{{ Baba is You
      games.baba-is-you = rec {
        name = "Baba Is You";
        developers = [ "Hempuli" ];
        release = "2019-03-10";
        description = "
          Baba Is You is an award-winning puzzle game where you can change the
          rules by which you play. In every level, the rules themselves are
          present as blocks you can interact with; by manipulating them, you
          can change how the level works and cause surprising, unexpected
          interactions! With some simple block-pushing you can turn yourself
          into a rock, turn patches of grass into dangerously hot obstacles,
          and even change the goal you need to reach to something entirely
          different.
        ";

        file = "${persistentStateDir}/baba-is-you/itch-install/run.sh";
        launch = mkSteamRunScript {
          inherit file;
          name = "baba-is-you";
        };

        assets = {
          poster = ./assets/baba-is-you/grid.jpg;
          logo = ./assets/baba-is-you/logo.png;
          icon = ./assets/baba-is-you/icon.jpg;
          background = ./assets/baba-is-you/background.jpg;
          screenshot = ./assets/baba-is-you/screenshot.jpg;
        };
      };
      # }}}
      # {{{ Ultrakill
      games.ultrakill = rec {
        name = "ULTRAKILL";
        developers = [ "Arsi \"Hakita\" Patala" ];
        release = "2020-09-03";
        description = "
          ULTRAKILL is a fast-paced ultraviolent retro FPS combining the
          skill-based style scoring from character action games with
          unadulterated carnage inspired by the best shooters of the '90s. Rip
          apart your foes with varied destructive weapons and shower in their
          blood to regain your health. 
        ";

        # TODO: Handle the actual launching of the game :/
        file = "${persistentStateDir}/baba-is-you/itch-install/bin64/Chowdren";
        launch = mkUmuScript {
          inherit file;
          name = "ultrakill";
        };

        assets = {
          poster = ./assets/ultrakill/grid.jpg;
          logo = ./assets/ultrakill/logo.png;
          icon = ./assets/ultrakill/icon.jpg;
          background = ./assets/ultrakill/background.jpg;
          screenshot = ./assets/ultrakill/screenshot.jpg;
        };
      };
      # }}}
    };
  };

  home.packages = [
    pkgs.lutris
    pkgs.wine64
    (upkgs.heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
        pkgs.gamemode
      ];
    })
  ];

  # {{{ COTN importer
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
  # }}}
}
