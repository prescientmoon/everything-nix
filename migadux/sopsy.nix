{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyyaml,
}:
buildPythonPackage {
  name = "sopsy";
  pyproject = true;
  build-system = [ hatchling ];
  dependencies = [ pyyaml ];
  src = fetchFromGitHub {
    owner = "nikaro";
    repo = "sopsy";
    rev = "9da81ce56160725bf60fc930f2010525c0b60980";
    sha256 = "0nnz2ah3gqgvcsagngijvsb4qw7cislq843rgj5bjqnx74kk8hpx";
  };
}
