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
rec {
  plymouthThemeCutsAlt = plymouthThemes.cuts_alt;
  vimclip = pkgs.callPackage (import ./vimclip.nix) { };
  homer = pkgs.callPackage (import ./homer.nix) { };

  octodns = pkgs.octodns.overrideAttrs (_: {
    version = "unstable-2024-10-08";
    src = pkgs.fetchFromGitHub {
      owner = "octodns";
      repo = "octodns";
      rev = "a1456cb1fcf00916ca06b204755834210a3ea9cf";
      sha256 = "192hbxhb0ghcbzqy3h8q194n4iy7bqfj9ra9qqjff3x2z223czxb";
    };
  });
  octodns-cloudflare = pkgs.python3Packages.callPackage (import ./octodns-cloudflare.nix) {
    inherit octodns;
  };
}
