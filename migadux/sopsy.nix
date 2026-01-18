{
  buildPythonPackage,
  fetchgit,
  hatchling,
  pyyaml,
}:
buildPythonPackage {
  name = "sopsy";
  pyproject = true;
  build-system = [ hatchling ];
  dependencies = [ pyyaml ];
  src = fetchgit {
    url = "https://git.sr.ht/~nka/sopsy";
    rev = "41579edc429e3f8731709823d0ddaceafa4a8726";
    sha256 = "09cdr5j3x5r6mpdasp3rskn0p2wpk6x7ddnpjj9f2gg5dp46ffjp";
  };
}
