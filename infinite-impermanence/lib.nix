{ lib }:
{
  # ["/home/user/" "/.screenrc"] -> "/home/user/.screenrc"
  concatPaths =
    paths:
    lib.optionalString (lib.hasPrefix "/" (lib.head paths)) "/"
    + lib.pipe paths [
      (lib.concatMap (builtins.split "/"))
      (lib.filter (s: builtins.typeOf s == "string" && s != ""))
      (lib.concatStringsSep "/")
    ];
}
