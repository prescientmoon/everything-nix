{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.satellite.machine.gaming {
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
    };
  };
}
