{ pkgs, ... }:
let uptimes = pkgs.writeShellScriptBin "uptimes" (builtins.readFile ./uptimes.sh);
in
{
  home.packages = [ uptimes ];
}
