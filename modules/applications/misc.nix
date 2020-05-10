{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    # cmd stuff
    tree # print a file structure
    exa # ls replacement
    mkpasswd # hash passwords
    gnupg
    typespeed

    # editors
    vscodium

    # chat apps
    discord
    slack
    zoom-us # for online classes / church and stuff

    # browsers
    google-chrome
    brave

    # other stuff
    spectacle # take screenshots
    vlc # video player
    gimp # image editing
    korganizer # calendar
    akonadi
  ];
}
