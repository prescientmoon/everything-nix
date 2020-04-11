{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    # I love combining these together and generating random stuff lol
    fortune
    cowsay
    lolcat
    figlet
    toilet

    # stuff to look at
    doge
    sl
    asciiquarium
    cmatrix
  ];
}
