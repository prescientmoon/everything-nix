{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
    extraConfig.filters."text/plain" = "wrap -w 100 | colorize";
  };

  # Using "programs.aerc.extraBinds" overrides every default binding, and
  # there's no point in translating them all to Nix. Having them in a separate
  # files thus makes them easier to modify
  xdg.configFile."aerc/binds.conf".source = ./binds.conf;

  xdg.configFile."aerc/stylesets/default".source =
    let
      catppuccinAerc = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "aerc";
        rev = "3580c723ee071e512d5e41bf88cea837b4f23746";
        sha256 = "1v8j8h9i473za7m8lq9ig7y3kb8rhyqijqiwxi96xfkpwvqn90cd";
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
    config.satellite.theming.get themeMap;
}
