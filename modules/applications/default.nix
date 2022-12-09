{ ... }: {
  imports = [
    ./git
    ./shells
    # ./wakatime
    ./rofi
    # ./xmodmap

    # ./wine.nix
    ./kdeconnect.nix
    ./steam.nix
    ./docker.nix
    ./misc.nix
    ./zathura.nix
    ./discord.nix
    ./locale.nix
    # ./memes.nix
    ./alacritty.nix
    # ./postgres.nix
    ./neovim.nix
    ./tmux.nix
    ./kmonad.nix
    ./direnv.nix
    # ./chromium.nix
    ./vieb.nix
    ./polybar.nix
    ./hamachi.nix
  ];
}

