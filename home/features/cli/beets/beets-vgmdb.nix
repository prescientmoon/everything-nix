{
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  lxml,
  beautifulsoup4,
  beets-minimal,
  setuptools,
}:
buildPythonPackage {
  name = "beets-vgmdb";
  src = fetchFromGitHub {
    owner = "HOZHENWAI";
    repo = "Beets-Plugin_VGMdb";
    rev = "c1e644ad60de722305d31628998def2b89c1db1d";
    sha256 = "0bpvsk7nv4899cx3rq2ahwh4i8gladn51lkckn404iwc4hjqdimw";
  };

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    requests
    lxml
    beautifulsoup4
  ];

  nativeBuildInputs = [
    beets-minimal
  ];

  postPatch = ''
    substituteInPlace requirements.txt --replace-fail "pathlib" ""
  '';
}
