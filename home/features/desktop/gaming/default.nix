{ config, pkgs, ... }:
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
in
{
  home.packages = [
    pkgs.vvvvvv
    pkgs.lutris
    pkgs.wine64
    pkgs.pegasus-frontend
  ];

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

  # {{{ Persistence
  satellite.persistence.at.state.apps.steam = {
    directories = [
      ".factorio"
      "${config.xdg.dataHome}/Steam"
      "${config.xdg.dataHome}/VVVVVV"
      "${config.xdg.dataHome}/Baba_Is_You"
      "${config.xdg.configHome}/unity3d/Team Cherry"
    ];
  };
  # }}}
}
