{ lib, fetchurl, ... }:
lib.fix (self: {
  "Catppuccin Mocha" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    sha256 = "1zw1vmksn4hi0mr5w9k23l18agvkis0fih69yjsm7x4a2dqfq35h";
  };
  "Catppuccin Frappe" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-frappe.theme.css";
    sha256 = "1x94q0k3f3mclkx6hibyjnl8fgjz39snbr8sqm5kjkyavv6hbhif";
  };
  "Catppuccin Latte" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-latte.theme.css";
    sha256 = "0884c2yf0rq5rrx4hl42f6kb6kjn1mz6122sf9qzl7lqkgm1d808";
  };
  "Catppuccin Macchiato" = fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css";
    sha256 = "1525shpzslnjxp1yqm98zpicrypy7zh79hi2pr85qcqcfn05v9gh";
  };
  default.dark = self."Catppuccin Macchiato";
  default.light = self."Catppuccin Latte";
})
