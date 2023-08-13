# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }:
let plymouthThemes = pkgs.callPackage (import ./plymouth-themes.nix) { }; in
{
  # example = pkgs.callPackage (import ./example.nix) {};
  vimclip = pkgs.callPackage (import ./vimclip.nix) { };
  wofi-pass = pkgs.callPackage (import ./wofi-pass.nix) { };

  plymouthThemeCutsAlt = plymouthThemes.cuts_alt;
}
