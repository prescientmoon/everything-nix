# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { }, upkgs ? pkgs }:
let plymouthThemes = pkgs.callPackage (import ./plymouth-themes.nix) { }; in
{
  # example = pkgs.callPackage (import ./example.nix) {};
  vimclip = pkgs.callPackage (import ./vimclip.nix) { };
  homer = pkgs.callPackage (import ./homer.nix) { };

  # REASON: octodns not in nixpkgs 23.11
  octodns-cloudflare = upkgs.python3Packages.callPackage (import ./octodns-cloudflare.nix) { };

  plymouthThemeCutsAlt = plymouthThemes.cuts_alt;
}
