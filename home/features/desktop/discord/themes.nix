{ lib, fetchurl, ... }:
lib.fix (self: {
  "Catppuccin Mocha" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    sha256 = "1agw88vg2dh948365mx8x7hzvghvscdpqhm70icg2x6bs5zszg9l";
  };
  "Catppuccin Frappe" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css";
    sha256 = "0rrz71n05jb0fd2jymis43i325y87qwrb5s6rryh8gd8anbk8h6y";
  };
  "Catppuccin Latte" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-latte.theme.css";
    sha256 = "HixxRdOTU7RynNseRWAWd4VzqYoX52n2nWlt9DX5MS8=";
  };
  "Catppuccin Macchiato" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css";
    sha256 = "1dgq1sdy07m0ra3ysn1g29y2ba37cna3sxy2vv125f2pjmdx0vci";
  };
  default.dark = self."Catppuccin Macchiato";
  default.light = self."Catppuccin Latte";
})
