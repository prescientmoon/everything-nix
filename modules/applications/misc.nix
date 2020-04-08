{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    mkpasswd
    vscodium
    google-chrome
    discord
    spectacle
  ];
}
