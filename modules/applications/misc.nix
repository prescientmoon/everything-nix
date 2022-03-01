{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    # cmd stuff
    tree # print a file structure
    exa # ls replacement
    mkpasswd # hash passwords
    gnupg
    # typespeed # speed typing game
    # unixtools.xxd # to dump binary stuff into a text file (used it for a ctf)
    # youtube-dl # download from youtube
    neofetch # display system information
    xclip # copy paste stuff
    # feh # image viewer
    unzip # for working with .zip files
    speedtest-cli # test the internet speed and stuff
    # openssl
    # pkgconfig
    # ngrok
    # hugo
    unrar
    # jdk11o
    # jdk8
    # gtk3
    gnumake
    # unison-ucm    
    xorg.libX11
    okular
    zathura
    cmake
    # kdeconnect

    # editors
    # vscodium
    vscode
    # vim
    # emacs

    # chat apps
    discord
    # deluge
    # slack
    # tdesktop # telegram for the desktop
    zoom-us
    # teams

    # browsers
    google-chrome
    # brave
    # firefox

    # other stuff
    obsidian # knowedge base
    # milkytracker # music tracker thingy
    spectacle # take screenshots
    vlc # video player
    gimp # image editing
    # korganizer # calendar
    libreoffice # free office suite
    # edopro # yugioh simulator (my derivation doesn't work yet)
    # akonadi
    # obs-studio # video recorder
    # blueman # bluetooth manager
    # freesweep # minesweeper I can play w the keyboard.
    # multimc
    sloc # line of code counter

    # Nes emulators and stuff
    # zsnes
    # higan
    # fceux

    # games
    tetrio-desktop
    # mindustry
    # edopro
  ];
}
