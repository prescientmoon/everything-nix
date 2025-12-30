{ buildPythonApplication, lib }:
buildPythonApplication {
  name = "historia";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = ./main.py;
  };

  format = "other";
  installPhase = ''
    mkdir -p $out/bin
    install -m755 main.py $out/bin/historia
  '';
}
