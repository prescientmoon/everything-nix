{
  config,
  pkgs,
  upkgs,
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

  steamDir = "${config.xdg.dataHome}/Steam";
  steamGameDir = "${steamDir}/steamapps/common/Rain World";
  gameDir = "${config.home.homeDirectory}/media/games";
  heroicGameDir = "${gameDir}/heroic";
  heroicConfigDir = "${config.xdg.configHome}/heroic";
  heroicDataDir = "${config.xdg.dataHome}/heroic";

  mkUmuScript =
    {
      name,
      file,
      prefix ? "/persist/state${config.home.homeDirectory}/${name}/prefix",
    }:
    pkgs.writeShellScript "umu-${name}" ''
      PROTONPATH="${heroicConfigDir}/tools/proton/GE-Proton-latest" \
      WINEPREFIX="${prefix}" \
      ${pkgs.umu-launcher}/bin/umu-run "${file}"
    '';

in
{
  imports = [ ./pegasus.nix ];

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

    babaIsYou = mkSteamGame "Baba Is You" "736260" (
      pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/81616e9ab54cc3e36260f80593a4cc33.png";
        sha256 = "1c00mk2p8rh6dnr8zsv1fx4a3rcl174fy7pxmi29mj1d3x6h2hhw";
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

    steam.directories = [
      steamDir

      # TODO(2025-12-16): move these to their own directories
      ".factorio"
      "${config.xdg.dataHome}/VVVVVV"
      "${config.xdg.dataHome}/Baba_Is_You"
      "${config.xdg.configHome}/unity3d/Team Cherry"
    ];

    heroic.directories = [
      heroicConfigDir
      heroicDataDir # I store wine prefixes here (will try to move them out though)

      # TODO(2025-12-16): This tip is probably obsolete
      # Apparently IO intensive stuff like games works better with symlinks?
      {
        directory = heroicGameDir;
        method = "symlink";
      }
    ];

    # There might be more to cache in `.cache/lutris`, but this works for now
    lutris.directories = [
      "${config.xdg.configHome}/lutris" # General configuration data
      "${config.xdg.cacheHome}/lutris/banners" # Game banners
      "${config.xdg.cacheHome}/lutris/coverart" # Game cover art

      {
        directory = "${gameDir}/lutris";
        method = "symlink";
      }
    ];

    pegasus.directories = [
      "${config.xdg.configHome}/pegasus-frontend"
    ];
  };

  satellite.persistence.at.cache.apps = {
    umu.directories = [
      "${config.xdg.dataHome}/umu"
      "${config.xdg.cacheHome}/umu"
      "${config.xdg.cacheHome}/umu-protonfixes"
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
        tags = [
          "beyond"
          "roguelike"
        ];

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
      # {{{ Crypt of the necrodancer
      games.crypt-of-the-necrodancer = rec {
        name = "Crypt of the NecroDancer";
        developers = [
          "Brace Yourself Games"
          "Blitworks"
        ];
        release = "2015-04-23";
        description = "Crypt of the NecroDancer is an award winning hardcore roguelike rhythm game. Move to the music and deliver beatdowns to the beat! Groove to the epic Danny Baranowsky soundtrack, or select songs from your own MP3 collection!";
        tags = [
          "rhythm"
          "roguelike"
        ];

        file = "${gameDir}/freestanding/crypt-of-the-necrodancer/game/NecroDancer.exe";
        launch = mkUmuScript {
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
        tags = [
          "beyond"
        ];

        file = "${steamGameDir}/RainWorld.exe";
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
    };
  };

  home.packages = [
    pkgs.vvvvvv # TODO(2025-12-16): add this to pegasus
    pkgs.lutris
    pkgs.wine64
    (upkgs.heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
        pkgs.gamemode
      ];
    })
  ];
}
