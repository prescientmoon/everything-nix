{ pkgs, ... }: {
  stylix.fonts = {
    monospace = {
      name = "Iosevka";
      package = pkgs.iosevka;
    };

    sansSerif = {
      name = "CMUSansSerif";
      package = pkgs.cm_unicode;
    };

    serif = {
      name = "CMUSerif-Roman";
      package = pkgs.cm_unicode;
    };

    sizes = {
      desktop = 14;
      applications = 17;
    };
  };
}
