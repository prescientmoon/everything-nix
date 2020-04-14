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

    # browsers
    google-chrome
    brave

    # other stuff
    spectacle # take screenshots
    unstable.elementary-planner # project planner
    vlc # video player
  ];
}
