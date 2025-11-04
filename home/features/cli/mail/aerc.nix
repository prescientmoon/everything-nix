{
  config,
  pkgs,
  lib,
  ...
}:
let
  catppuccinAerc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "aerc";
    rev = "3580c723ee071e512d5e41bf88cea837b4f23746";
    sha256 = "";
  };

  themeMap = lib.fix (self: {
    "Catppuccin Mocha" = "${catppuccinAerc}/dist/catppuccin-mocha";
    "Catppuccin Latte" = "${catppuccinAerc}/dist/catppuccin-latte";
    "Catppuccin Frappe" = "${catppuccinAerc}/dist/catppuccin-frappe";
    "Catppuccin Macchiato" = "${catppuccinAerc}/dist/catppuccin-macchiato";

    default.light = self."Catppuccin Latte";
    default.dark = self."Catppuccin Macchiato";
  });
in
{
  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };
}
