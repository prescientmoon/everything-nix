{ pkgs, ... }: {
  stylix.fonts = {
    # monospace = { name = "Iosevka"; package = pkgs.iosevka; };
    monospace = { name = "Cascadia Code"; package = pkgs.cascadia-code; };
    sansSerif = { name = "CMUSansSerif"; package = pkgs.cm_unicode; };
    serif = { name = "CMUSerif-Roman"; package = pkgs.cm_unicode; };

    sizes = {
      desktop = 13;
      applications = 15;
    };
  };
}
