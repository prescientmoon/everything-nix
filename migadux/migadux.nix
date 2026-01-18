{
  buildPythonApplication,
  requests,
  sopsy,
  lib,
}:
buildPythonApplication {
  name = "migadux";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = ./main.py;
  };

  format = "other";
  dependencies = [
    requests
    sopsy
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 main.py $out/bin/migadux
  '';
}
