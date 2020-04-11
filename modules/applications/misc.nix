{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    # cmd stuff
    tree # print a file structure
    exa # ls replacement
    mkpasswd # hash passwords
    gnupg

    # editors
    vscodium

    # chat apps
    discord
    slack

    # gui studf
    google-chrome
    spectacle # take screenshots
    unstable.elementary-planner # project planner

    # for the memes
    fortune
    cowsay
    lolcat
    figlet
  ];
}
