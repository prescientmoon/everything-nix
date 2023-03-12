{ config, pkgs, ... }:
{
  xsession.initExtra =
    "${pkgs.feh}/bin/feh --no-fehbg --bg-fill ${config.stylix.image}";
}
