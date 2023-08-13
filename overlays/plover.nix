# Taken from [here](https://github.com/openstenoproject/plover/pull/1461#issuecomment-1094511201)
# Wayland version of plover
(final: prev: rec {
  python3Packages = {
    plover-stroke = final.python3Packages.buildPythonPackage rec {
      pname = "plover_stroke";
      version = "1.0.1";
      src = prev.python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "t+ZM0oDEwitFDC1L4due5IxCWEPzJbF3fi27HDyto8Q=";
      };
    };
    rtf-tokenize = final.python3Packages.buildPythonPackage rec {
      pname = "rtf_tokenize";
      version = "1.0.0";
      src = prev.python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "XD3zkNAEeb12N8gjv81v37Id3RuWroFUY95+HtOS1gg=";
      };
    };
    pywayland_0_4_7 = prev.python3Packages.pywayland.overridePythonAttrs
      (oldAttrs: rec {
        pname = "pywayland";
        version = "0.4.7";
        src = prev.python3Packages.fetchPypi {
          inherit pname version;
          sha256 = "0IMNOPTmY22JCHccIVuZxDhVr41cDcKNkx8bp+5h2CU=";
        };
      });
  } // prev.python3Packages;
  plover.dev = prev.plover.dev.overridePythonAttrs
    (oldAttrs: {
      src = final.fetchFromGitHub {
        owner = "openstenoproject";
        repo = "plover";
        rev = "fd5668a3ad9bd091289dd2e5e8e2c1dec063d51f";
        sha256 = "2xvcNcJ07q4BIloGHgmxivqGq1BuXwZY2XWPLbFrdXg=";
      };
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs
        ++ [
        python3Packages.plover-stroke
        python3Packages.rtf-tokenize
        python3Packages.pywayland_0_4_7
      ];
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
        final.pkg-config
      ];
      doCheck = false; # TODO: get tests working
      postPatch = ''
        sed -i /PyQt5/d setup.cfg
        substituteInPlace plover_build_utils/setup.py \
          --replace "/usr/share/wayland/wayland.xml" "${final.wayland}/share/wayland/wayland.xml"
      '';
    });
})
