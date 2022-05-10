{ lib, ... }:
self: super:
let
  allThemes = self.callPackage (import ../themes/themes.nix) { };
  currentTheme = "github-light";
in
with self; {
  myHelpers = self.callPackage (import ../helpers.nix) { };
  myThemes = {
    all = allThemes;
    current = lib.lists.findFirst (theme: theme.name == currentTheme)
      (throw ''
        Theme "${currentTheme}" not found.
        Available themes are:
          ${lib.lists.foldr (current: prev: if prev == "" 
            then current.name 
            else "${current.name}, ${prev}") "" allThemes}
      '')
      allThemes;
  };
}

