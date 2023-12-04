{ pkgs, ... }:
pkgs.mkShell {
  pacakges = with pkgs; [
    stylua
    lua-language-server
    lua
  ];
}
