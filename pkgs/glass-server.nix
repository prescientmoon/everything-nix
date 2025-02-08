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
    rev = "ab5cea3b7b998bfa13f362571ab3252e2e02c98a";
    sha256 = "p4S79TfAB5ffTosjfZVrKiJ8FnspT/ceuIg2f1cQZ9Y=";
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
