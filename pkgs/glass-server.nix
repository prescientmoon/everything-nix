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
    rev = "b4deb5cfe990936a698188acf381b7ce716d15b8";
    sha256 = "i+A9N7vxrvDdB5t/mJLQz1IjPQUwBSFbl0Wcr7Bm51U=";
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
