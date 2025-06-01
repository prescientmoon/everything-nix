{ pkgs, ... }:
{
  imports = [
    ./bat.nix
    ./catgirl.nix
    ./direnv.nix
    ./eza.nix
    ./git.nix
    ./lazygit.nix
    ./ssh.nix
    ./tealdeer.nix
    ./yazi.nix
    ./fish
  ];

  # Enable basic CLI thingies
  programs.bash.enable = true;
  programs.broot.enable = true;
  programs.starship.enable = true;

  # Enable nix-index
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;

  home.packages = with pkgs; [
    # System information
    acpi # Battery stats
    neofetch # Display system information
    tokei # Useless but fun line of code counter (sloc alternative)
    bottom # System monitor
    bandwhich # Network bandwhich info

    # Storage
    dua # du + ncdu replacement
    dust # Similar to du, but with prettier output
    dysk # Similar to df, but with prettier output

    # Alternatives to usual commands
    ripgrep # Better grep
    fd # Better find
    sd # Better sed
    httpie # Better curl

    # Misc
    ouch # Unified compression / decompression tool
    mkpasswd # Hash passwords
    jq # JSON manipulation
    ffsend # File sharing

    # Normally, I'd recommend against installing this globally, although
    # it seems the completions don't play nicely with direnv otherwise.
    just
  ];

  home.shellAliases = {
    # -h: humans readable units
    df = "df -h";
    du = "du -h";

    # duh: short for `du here`
    # -d: depth
    duh = "du -hd 1";
  };
}
