{ pkgs, ... }:
{
  stylix.fonts = {
    # monospace = { name = "Iosevka"; package = pkgs.iosevka; };
    monospace = {
      name = "Maple Mono NF";
      package = pkgs.maple-mono.NF;
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
      desktop = 15;
      applications = 17;
      terminal = 25;
    };
  };

  stylix.targets.fontconfig.enable = true;
  stylix.targets.font-packages.enable = true;
}
