{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
    playonlinux
  ];
}
