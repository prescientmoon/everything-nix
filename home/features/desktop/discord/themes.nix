{ lib, fetchurl, ... }:
lib.fix (self: {
  "Catppuccin Mocha" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    sha256 = "0nv36q310mbm0p5v8anvz98bq68p9m3969rlp464m3mqkj8aszg2";
  };
  "Catppuccin Frappe" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css";
    sha256 = "1d55rxp5z0c4m0g6qn6y28mrps7psfgvag1yf0h2ac3znmmyjrqk";
  };
  "Catppuccin Latte" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-latte.theme.css";
    sha256 = "1m0vjq3bj62rm9n5cabpqhghxyaj1676q9k83z7dabsqq3d4blpv";
  };
  "Catppuccin Macchiato" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css";
    sha256 = "1wnphnzgv90r5zgxrr5w36pm1wa5qmkyb72gylj4j1wrk3h7vfvc";
  };
  default = self."Catppuccin Macchiato";
})
