# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{
  pkgs ? (import ../nixpkgs.nix) { },
  upkgs ? pkgs,
  ...
}:
let
  plymouthThemes = pkgs.callPackage (import ./plymouth-themes.nix) { };
in
{
  plymouthThemeCutsAlt = plymouthThemes.cuts_alt;
  vimclip = pkgs.callPackage (import ./vimclip.nix) { };
  homer = pkgs.callPackage (import ./homer.nix) { };
}
