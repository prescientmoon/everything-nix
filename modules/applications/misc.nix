{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    # cmd stuff
    tree # print a file structure
    exa # ls replacement
    mkpasswd # hash passwords
    gnupg
    typespeed # speed typing game
    unixtools.xxd # to dump binary stuff into a text file (used it for a ctf)
    youtube-dl # download from youtube
    neofetch # display system information
    xclip # copy paste stuff
    feh # image viewer

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
    milkytracker # music tracker thingy
    spectacle # take screenshots
    vlc # video player
    gimp # image editing
    korganizer # calendar
    libreoffice # free office suite
    # edopro # yugioh simulator (my derivation doesn't work yet)
    akonadi
  ];
}
