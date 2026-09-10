{ lib, pkgs, ... }:
let
  base = pkgs.vim-classic;
  deps = [ pkgs.update-nix-fetchgit ];
in
pkgs.symlinkJoin {
  inherit (base) name meta;
  paths = [ base ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/vim \
      --prefix PATH : ${lib.makeBinPath deps}
  '';
}
