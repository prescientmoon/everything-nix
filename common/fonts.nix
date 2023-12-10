{ pkgs, ... }: {
  stylix.fonts = {

    # monospace = {
    #   name = "Cascadia Code";
    #   package = pkgs.cascadia-code;
    # };

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

    # Why would you not want sansSerif
    # (that's what I used to think, but I have since changed my mind)
    # serif = sansSerif;
  };
}
