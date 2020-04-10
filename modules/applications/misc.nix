{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    tree
    mkpasswd
    gnupg
    vscodium
    google-chrome
    discord
    slack
    spectacle
  ];
}
