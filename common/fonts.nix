{ pkgs, ... }: {
  stylix.fonts = rec {
    monospace = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
    };

    sansSerif = {
      name = "Fira Sans";
      package = pkgs.fira;
    };

    # Why would you not want sansSerif
    serif = sansSerif;
  };
}
