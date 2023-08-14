# shell containing the tools i most commonly use for purescript work!
{ pkgs, upkgs, ... }:
pkgs.mkShell {
  # reason: purescript 0.15.10
  nativebuildinputs = with pkgs; [ upkgs.purescript spago typescript nodejs ];
}
