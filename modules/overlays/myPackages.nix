self: super:
with self; {
  myHelpers = self.callPackage (import ../helpers.nix) { };
  myThemes = self.callPackage (import ../themes/themes.nix) { };
}
