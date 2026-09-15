{ lib }:
{
  # I left this here to keep this module self contained, even though I might
  # have copies of it in other parts of the repo already.
  concatPaths =
    paths:
    lib.optionalString (lib.hasPrefix "/" (lib.head paths)) "/"
    + lib.pipe paths [
      (lib.concatMap (builtins.split "/"))
      (lib.filter (s: builtins.typeOf s == "string" && s != ""))
      (lib.concatStringsSep "/")
    ];
}
