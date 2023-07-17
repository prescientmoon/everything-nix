{ pkgs, ... }: {
  imports = [
    ./exa.nix
    ./bat.nix
    ./ssh.nix
    ./git.nix
    ./starship.nix
    ./direnv.nix
    ./fish
    ./tmux
  ];

  # Enable bash
  programs.bash.enable = true;

  # Install clis
  home.packages = with pkgs; [
    ranger # Terminal file explorer
    comma # Intstall and run programs by sticking a , before them
    bc # Calculator
    ncdu # TUI disk usage
    du-dust # Similar to du and ncdu in purpose.
    ripgrep # Better grep
    fd # Better find
    sd # Better sed
    httpie # Better curl
    mkpasswd # Hash passwords
    neofetch # Display system information
    zip # Zipping files
    unzip # Unzipping files
    unrar # For extracting shit from rars
    tokei # Useless but fun line of code counter (sloc alternative)
    bottom # System monitor
    tldr # Example based cli docs
  ];
}
