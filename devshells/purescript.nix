# shell containing the tools i most commonly use for purescript work!
{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [ purescript spago typescript nodejs ];
}
