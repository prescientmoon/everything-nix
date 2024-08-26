{ lib, fetchurl, ... }:
lib.fix (self: {
  "Catppuccin Mocha" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    sha256 = "1gafrnm5mz8zh63zvcr3jp5fkzs9l0xnpwq3b4k7sbbzwg04nzw5";
  };
  "Catppuccin Frappe" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css";
    sha256 = "05y43fcwgy4sv9q6c49r5c92jzvq8vjrk05wy2zblp5v7zrli7sl";
  };
  "Catppuccin Latte" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-latte.theme.css";
    sha256 = "1c7vwr8f6sip7lsyp770hm170pnld1ikvqdsh2fxlsdkkn6ay2k3";
  };
  "Catppuccin Macchiato" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css";
    sha256 = "11vig9i5kwhcbblspcp928gf4mvvp3v0qsibmh82wyxyw9ddzr7d";
  };
  default.dark = self."Catppuccin Macchiato";
  default.light = self."Catppuccin Latte";
})
