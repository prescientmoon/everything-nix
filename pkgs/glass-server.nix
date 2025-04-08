{
  pkgs ? import <nixpkgs> { },
}:
let
  python3 = pkgs.python3.withPackages (
    ps: with ps; [
      flask
      cryptography
      limits
    ]
  );
in
pkgs.stdenv.mkDerivation {
  pname = "arcaea-server-fork";
  version = "unstable-2025-02-07";

  src = pkgs.fetchFromGitHub {
    owner = "starlitcanopy";
    repo = "ArcaeaServerFork";
    rev = "2ee761f49462eabd6e26d2951cdd32205808261c";
    sha256 = "i0h3lXo1k99h0h1P4VIFoYvugOtcY4vZZx9+8L//z1A=";
  };

  buildPhase = ''
    runHook preBuild

    echo "#!/usr/bin/env bash" > glass-server
    echo "${python3}/bin/python $out/source/main.py" >> glass-server

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 glass-server -t $out/bin/
    mkdir -p $out/source
    cp -r * $out/source
    rm $out/source/glass-server

    runHook postInstall
  '';
}
