{ pkgs, inputs, ... }: {
  imports = [
    ./eza.nix
    ./bat.nix
    ./ssh.nix
    ./gpg.nix
    ./git.nix
    ./starship.nix
    ./direnv.nix
    ./fish
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
    ouch # Unified compression / decompression tool
    mkpasswd # Hash passwords
    neofetch # Display system information
    tokei # Useless but fun line of code counter (sloc alternative)
    bottom # System monitor
    tldr # Example based cli docs
    inputs.agenix.packages.${pkgs.system}.agenix # Secret encryption
    inputs.deploy-rs.packages.${pkgs.system}.default # Deployment
  ];
}
