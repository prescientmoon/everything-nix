{ lib, fetchurl, ... }:
lib.fix (self: {
  "Catppuccin Mocha" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    sha256 = "0y9vha3gb48yid65r2zfkc6l021j1s8mlac3klkbksla9gqnd9wr";
  };
  "Catppuccin Frappe" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css";
    sha256 = "19kmmydkbpig14ql6zn0vqzlfykm6qg7r317vwjzq9dg092lflam";
  };
  "Catppuccin Latte" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-latte.theme.css";
    sha256 = "0lm1mzflyxmzpsyfkbcd1v7d1xp5i683yc6npbsm12z4hqn2smf6";
  };
  "Catppuccin Macchiato" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css";
    sha256 = "01zd5zf9b4a2kkwnkpzg37g1macan6201wyi7zj2crsbxy8b7j6k";
  };
  default.dark = self."Catppuccin Macchiato";
  default.light = self."Catppuccin Latte";
})
