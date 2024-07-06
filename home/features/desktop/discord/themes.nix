{ lib, fetchurl, ... }:
lib.fix (self: {
  "Catppuccin Mocha" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    sha256 = "01j5xhzpy3a68qlrzchzclj7mnxj106bwxq2vyvxw7fd2n3zn96b";
  };
  "Catppuccin Frappe" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css";
    sha256 = "037jr133zw04sslkl1hdspkqqb40c3a7hcs72lzjlimaqhnxd044";
  };
  "Catppuccin Latte" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-latte.theme.css";
    sha256 = "1bijp2ysm7ifah6xqz95ag4hi7k7r0s9c8jz0s5a4b00k59qd6qc";
  };
  "Catppuccin Macchiato" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css";
    sha256 = "1ggw9iyn7d7z0sv784kgmxbf94xvwn2cnkd8g08xzy5c17gky6ln";
  };
  default.dark = self."Catppuccin Macchiato";
  default.light = self."Catppuccin Latte";
})
