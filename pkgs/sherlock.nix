# Up to date version of [this](https://github.com/NixOS/nixpkgs/blob/nixos-22.11/pkgs/tools/security/sherlock/default.nix)
{ stdenv, lib, fetchFromGitHub, python3, makeWrapper }:
let
  pyenv = python3.withPackages (pp: with pp; [
    beautifulsoup4
    certifi
    colorama
    lxml
    pysocks
    requests
    requests-futures
    soupsieve
    stem
    torrequest
    pandas
  ]);
in
stdenv.mkDerivation {
  pname = "sherlock";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = "sherlock";
    rev = "61bb34b0213482164247df496a063b9e41b98f78";
    sha256 = "0lnwph8vvxj47bx3dys4f2g4zixp791xhhijwa4y81rihlr0q89l";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace sherlock/sherlock.py \
      --replace "os.path.dirname(__file__)" "\"$out/share\""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    cp ./sherlock/*.py $out/bin/
    cp --recursive ./sherlock/resources/ $out/share
    makeWrapper ${pyenv.interpreter} $out/bin/sherlock --add-flags "$out/bin/sherlock.py"
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    cd $srcRoot/sherlock
    ${pyenv.interpreter} -m unittest tests.all.SherlockSiteCoverageTests --verbose
    runHook postCheck
  '';
}
