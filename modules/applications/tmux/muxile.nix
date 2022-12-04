{ pkgs, ... }:
let dependencies = [ pkgs.qrencode pkgs.jq pkgs.websocat ];
in
pkgs.tmuxPlugins.mkTmuxPlugin
{
  pluginName = "muxile";
  version = "unstable-2021-08-08";
  src = pkgs.fetchFromGitHub
    {
      owner = "bjesus";
      repo = "muxile";
      sha256 = "12kmcyizzglr4r7nisjbjmwmw1g4hbwpkil53zzmq9wx60l8lwgb";
      rev = "7310995ed1827844a528a32bb2d3a3694f1c4a0d";
    };
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postInstall = ''
    for f in $target/scripts/*.sh; do
      wrapProgram $f \
        --prefix PATH : ${lib.makeBinPath dependencies}
    done
  '';
}
