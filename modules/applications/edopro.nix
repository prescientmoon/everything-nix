# TODO: make this actually build
{ pkgs, stdenv, ... }:
let
  # It's considered good practice to specify the version in the derivation name
  version = "38.1.1";
  # In case the name they build it into changes I can just modify this
  execName = "EDOPro";
  edopro = stdenv.mkDerivation rec {
    name = "edopro-${version}";

    src = builtins.path {
      path = pkgs.fetchurl {
        url =
          "https://mega.nz/file/pfglCAyK#IlqEOy1kBLmFiIDu4z6afbj1wTcWTFTyvYzPW0D2m24";
        sha256 =
          "99be240086ccae834998b821df5abb17f7d22d26fb757fc5106b4812ca4b3f36";
      };
      name = "edopro-source";
    };

    # Add the derivation to the PATH
    buildInputs = with pkgs; [
      mono # this is needed for the ai support
      freetype # font rendering engine
    ];

    # This just moves the bin over and calls it a day
    installPhase = ''
      # Make the output directory
      mkdir -p $out/bin

      # Copy the script there and make it executable
      cp ${execName} $out/bin/
      chmod +x $out/bin/${execName}
    '';
  };

in stdenv.mkDerivation {
  name = "edopro-environment";
  buildInputs = [ edopro ];
}
