{ ... }: {
  imports = [
    ./git
    ./shells
    # ./wakatime
    ./xmonad
    ./xmodmap

    # ./wine.nix
    ./kdeconnect
    ./steam.nix
    ./docker.nix
    ./misc.nix
    ./locale.nix
    # ./memes.nix
    ./alacritty.nix
    ./rofi.nix
    ./postgres.nix
    ./neovim.nix
  ];
}

