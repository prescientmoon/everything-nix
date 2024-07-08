{ lib
, buildPythonPackage
, fetchFromGitHub
, octodns
, pytestCheckHook
, pythonOlder
, dnspython
, setuptools
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "octodns-cloudflare";
  version = "unstable-2024-05-31";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-cloudflare";
    rev = "3c01938e280767f433eb276a75d6b02c152c02af";
    sha256 = "1dnvyvf6mlpqcsrj11192li2mhqfs8w6pvaqmsy3jsqjqczmgmf5";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    octodns
    dnspython
    requests
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [ "octodns_cloudflare" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];
}
