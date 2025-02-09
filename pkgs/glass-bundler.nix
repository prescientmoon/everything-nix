{
  pkgs ? import <nixpkgs> { },
}:
pkgs.stdenv.mkDerivation {
  pname = "arcaea-bundler";
  version = "unstable-2024-03-12";

  src = pkgs.fetchFromGitHub {
    owner = "Lost-MSth";
    repo = "Arcaea-Bundler";
    rev = "db1901f31407f623da161a76dde225899ce902de";
    sha256 = "0fd2yrg8g6iwzy6m1y0ijfz5aqfm5bh8n6dzhiswzpssp4znp6vz";
  };

  buildPhase = ''
    runHook preBuild
    echo "#!${pkgs.python3}/bin/python" > glass-bundler
    cat $src/arcaea_bundler/main.py >> glass-bundler
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 glass-bundler -t $out/bin/
    runHook postInstall
  '';
}
