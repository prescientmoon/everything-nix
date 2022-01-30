{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "edopro";
  version = "39.2.0";
  rev = "20210927";

  src = pkgs.fetchurl {
    url =
      "https://github.com/ProjectIgnis/edopro-assets/releases/download/${rev}/ProjectIgnis-EDOPro-${version}-linux.tar.gz";
  };

  buildInputs = [ pkgs.mono ];
  configurePhase = "";
  buildPhase = "";

  installPhase = ''
    mkdir -p $out/bin
    mv edopro $out/bin
  '';
}
