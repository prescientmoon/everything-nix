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
    rev = "e450a99cc3eec3504f934d9fd44f03647903bd62";
    sha256 = "4noCwKSSAFMlyvZfXUbgoXHyQr7cgitwr4wUjKTFu7A=";
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
