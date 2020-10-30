{ ... }: {
  imports = [
    ./git
    ./shells
    ./wakatime
    ./xmonad

    ./wine.nix
    ./docker.nix
    ./misc.nix
    ./locale.nix
    ./memes.nix
    ./alacritty.nix
    ./rofi.nix
    ./postgres.nix
  ];
}

