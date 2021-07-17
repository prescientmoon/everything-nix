{ pkgs, ... }: {
  home-manager.users.adrielus.home = {
    packages = [ pkgs.xorg.xmodmap ];
    file.".Xmodmap".source = ./.Xmodmap;
  };
  services.xserver.displayManager.sessionCommands =
    "${pkgs.xorg.xmodmap}/bin/xmodmap .Xmodmap";
}
