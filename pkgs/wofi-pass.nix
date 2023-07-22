{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "wofi-pass";
  version = "unstable-2023-05-12";

  src = pkgs.fetchFromGitHub {
    rev = "4468bbedf55ae1de47d178d39b60249d390b1d62";
    owner = "schmidtandreas";
    repo = "wofi-pass";
    sha256 = "01sdz5iq9rqgd54d27qqq7f8b5ck64b0908lj9c4nkyw3vcplzar";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ./wofi-pass $out/bin/wofi-pass
    chmod +x $out/bin/wofi-pass
  '';
}
