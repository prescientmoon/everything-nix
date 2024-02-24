{ lib, fetchzip, writeTextFile, runCommandLocal, symlinkJoin }:

let
  homer = fetchzip rec {
    pname = "homer";
    version = "24.02.1";
    url =
      "https://github.com/bastienwirtz/${pname}/releases/download/v${version}/${pname}.zip";
    hash = "sha256-McMJuZ84B3BlGHLQf+/ttRe5xAzQuR6qHrH8IjGys2Q=";
    stripRoot = false;

    passthru = {
      withAssets = { name ? null, config, extraAssets ? [ ] }:
        let nameSuffix = lib.optionalString (name != null) "-${name}";
        in
        symlinkJoin {
          name = "homer-root${nameSuffix}";
          paths = [
            homer
            (writeTextFile {
              name = "homer-configuration${nameSuffix}";
              text = builtins.toJSON config;
              destination = "/assets/config.yml";
            })
          ] ++ lib.optional (extraAssets != [ ])
            (runCommandLocal "homer-assets${nameSuffix}" { }
              (builtins.concatStringsSep "\n" (map
                (asset: ''
                  mkdir -p $out/assets/${dirOf asset}
                  ln -s ${asset} $out/assets/${asset}
                '')
                extraAssets)));
        };
    };
  };
in
homer
