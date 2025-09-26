{ pkgs, ... }:
{
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
      pkgs.gamescope
      pkgs.gamemode
    ];

    # package = pkgs.steam.override {
    #   extraPkgs =
    #     pkgs': with pkgs'; [
    #       xorg.libXcursor
    #       xorg.libXi
    #       xorg.libXinerama
    #       xorg.libXScrnSaver
    #       libpng
    #       libpulseaudio
    #       libvorbis
    #       stdenv.cc.cc.lib # Provides libstdc++.so.6
    #       libkrb5
    #       keyutils
    #     ];
    # };
  };

  # programs.steam.extraCompatPackages = with pkgs; [
  #   proton-ge-bin
  # ];
}
