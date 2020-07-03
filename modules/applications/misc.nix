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
    speedtest-cli # test the internet speed and stuff

    # editors
    vscodium
    vim
    neovim
    emacs
    # vscode

    # chat apps
    discord
    slack
    tdesktop # telegram for the desktop
    zoom-us

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
