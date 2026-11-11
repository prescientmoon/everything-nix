{
  inputs,
  pkgs,
  upkgs,
  ...
}:
{
  imports = [
    ./bat.nix
    ./calendar.nix
    ./catgirl.nix
    ./direnv.nix
    ./eza.nix
    ./git.nix
    ./lazygit.nix
    ./ssh.nix
    ./starship.nix
    ./tealdeer.nix
    ./yazi.nix
    ./beets
    ./fish
    ./mail

    inputs.nix-index-database.homeModules.nix-index
  ];

  # Enable basic CLI thingies
  programs.bash.enable = true;
  programs.broot.enable = true;

  # Enable nix-index
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;

  home.packages = with pkgs; [
    # System information
    acpi # Battery stats
    tokei # Useless but fun line of code counter (sloc alternative)
    bottom # System monitor
    bandwhich # Network bandwidth info

    # Alternatives to usual commands
    ripgrep # grep-like CLI
    fd # find-like CLI
    sd # sed-like CLI
    httpie # HTTP client

    # Misc
    # NOTE: only available from 26.05
    ouch-rar # Unified compression / decompression tool
    mkpasswd # Hash passwords
    jaq # JSON manipulation
    ffsend # File sharing
    file # Filetype detection
    moreutils # Contains some useful commands
    ffmpeg # Video operations
    imagemagick # Image operations

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

  # Disable GNU parallel citation notice
  home.file.".parallel/will-cite".text = "";
}
