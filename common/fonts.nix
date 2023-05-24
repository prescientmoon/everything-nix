{ pkgs, ... }: {
  stylix.fonts = {
    monospace = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
    };

    sansSerif = {
      name = "Fira Sans";
      package = pkgs.fira;
    };

    # Why would you not want sansSerif
    # (that's what I used to think, but I somewhat changed my mind)
    # serif = sansSerif;
  };
}
