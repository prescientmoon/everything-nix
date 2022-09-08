{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    # cmd stuff
    tree # print a directory structure
    exa # ls replacement
    mkpasswd # hash passwords
    gnupg # forgot what this was
    acpi # show remaining battery
    # typespeed # speed typing game
    # unixtools.xxd # to dump binary stuff into a text file (used it for a ctf)
    # youtube-dl # download from youtube
    neofetch # display system information
    xclip # copy paste stuff
    # feh # image viewer
    speedtest-cli # test the internet speed and stuff
    # openssl
    # pkgconfig
    # ngrok
    # hugo
    unzip # for working with .zip files
    unrar # for extracting shit from rars
    # jdk11o
    # jdk8
    # gtk3
    gnumake
    cmake
    # unison-ucm    
    xorg.libX11 # wtf is this
    okular # forgot what this does
    spotify-tui # spotify terminal ui
    # kdeconnect # connect with your phone
    sloc # line of code counter
    update-nix-fetchgit # for updating fetchgit calls in nix files
    pamixer # set pipewire volume
    pulseaudio # pactl and stuff (same thing as above)

    # editors
    # vscodium
    # vscode
    # vim
    # emacs
    vimclip # use neovim anywhere

    # chat apps
    # slack
    signal-desktop
    # tdesktop # telegram for the desktop
    # deluge
    zoom-us
    # teams

    # browsers
    unstable.google-chrome
    # brave
    # firefox

    # other stuff
    obsidian # knowedge base
    # milkytracker # music tracker thingy
    spectacle # take screenshots
    peek # record gifs 
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
    # lmms # music software

    # Nes emulators and stuff
    # zsnes
    # higan
    # fceux

    # games
    # tetrio-desktop # competitive tetris
    # vassal # wargame engine
    # mindustry # factory building game
    # edopro # yugioh sim
  ];
}
