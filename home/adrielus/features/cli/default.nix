{ pkgs, ... }: {
  imports = [ ./exa.nix ./bat.nix ./ssh.nix ./fish.nix ./tmux ./git.nix ./starship.nix ./direnv.nix ];

  # Enable bash
  programs.bash.enable = true;

  # Install clis
  home.packages = with pkgs; [
    ranger # Terminal file explorer
    comma # Intstall and run programs by sticking a , before them
    bc # Calculator
    ncdu # TUI disk usage
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    mkpasswd # Hash passwords
    neofetch # Display system information
    unzip # For working with .zip files
    unrar # For extracting shit from rars
    sloc # Useless but fun line of code counter
  ];
}
