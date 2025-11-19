{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.satellite.machine.gaming {
    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--backend"
        "sdl"
      ];
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      gamescopeSession.enable = true;
      extraPackages = [
        # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1229444338
        pkgs.xorg.libXcursor
        pkgs.xorg.libXi
        pkgs.xorg.libXinerama
        pkgs.xorg.libXScrnSaver
        pkgs.libpng
        pkgs.libpulseaudio
        pkgs.libvorbis
        pkgs.stdenv.cc.cc.lib
        pkgs.libkrb5
        pkgs.keyutils
      ];
    };
  };
}
