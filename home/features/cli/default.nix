{ pkgs, inputs, ... }: {
  imports = [
    ./eza.nix
    ./bat.nix
    ./ssh.nix
    ./gpg.nix
    ./git.nix
    ./starship.nix
    ./direnv.nix
    ./tealdeer.nix
    ./fish
  ];

  # Enable bash
  programs.bash.enable = true;

  # Install clis
  home.packages = with pkgs; [
    # {{{ System information 
    acpi # Battery stats
    neofetch # Display system information
    tokei # Useless but fun line of code counter (sloc alternative)
    bottom # System monitor
    # }}}
    # {{{ Storage 
    ncdu # TUI disk usage
    du-dust # Similar to du and ncdu in purpose.
    # }}}
    # {{{ Alternatives to usual commands
    ripgrep # Better grep
    fd # Better find
    sd # Better sed
    httpie # Better curl
    # }}}
    # {{{ Misc  
    ranger # Terminal file explorer
    comma # Intstall and run programs by sticking a , before them
    bc # Calculator
    ouch # Unified compression / decompression tool
    mkpasswd # Hash passwords
    inputs.agenix.packages.${pkgs.system}.agenix # Secret encryption
    # }}}
  ];

  # Set up common aliases
  home.shellAliases = {
    # {{{ Storage
    # -h = humans readable units
    df = "df -h";
    du = "du -h";

    # short for `du here`
    # -d = depth
    duh = "du -hd 1";
    # }}}
  };
}
