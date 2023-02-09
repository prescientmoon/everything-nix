# Actually installs the fonts and whatnot.
# In a different file so the main module 
# can also be included in my nixos config.
{ lib, config, ... }:
let   cfg = config.fontProfiles;
  in
{
  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [ cfg.monospace.package cfg.regular.package ];
  };
}
