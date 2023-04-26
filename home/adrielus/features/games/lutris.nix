{ pkgs, config, ... }: {
  home.packages = [
    pkgs.lutris
  ];

  home.persistence."/persist/home/adrielus".directories = [
    ".config/lutris" # General config data
    ".cache/lutris/banners" # Game banners
    ".cache/lutris/coverart" # Game cover art

    # Aparently IO intensive stuff like games prefer symlinks?
    { directory = "Games/Lutris"; method = "symlink"; } # Lutris games
  ];
}
