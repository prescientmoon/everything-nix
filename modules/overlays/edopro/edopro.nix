{ pkgs ? import <nixpkgs>, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "edopro";
  version = "39.2.0";
  rev = "20210927";

  src = pkgs.fetchurl {
    url =
      "https://github.com/ProjectIgnis/edopro-assets/releases/download/${rev}/ProjectIgnis-EDOPro-${version}-linux.tar.gz";
    sha256 = "OQSWTuRaTyr2XIDjSbIvrV11LJCpOmw5aOjHU2ji+kI=";
  };

  buildInputs = [ pkgs.mono ];
  configurePhase = "";
  buildPhase = "";

  installPhase = ''
    mkdir -p $out/bin
    ls
    chmod +x ./EDOPro
    mv ./* $out/bin/
  '';
}
