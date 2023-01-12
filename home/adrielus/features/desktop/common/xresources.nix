{ config, pkgs, ... }:
let base16-xresources = pkgs.fetchFromGitHub {
  owner = "tinted-theming";
  repo = "base16-xresources";
  sha256 = "151zahx18vfrmbll7lwwnb17rn4z0di8n0fi2yr10hg14azddb2r";
  rev = "6711cf4fa61e903e52ef6eac186b83e04a0397d8";
};
in
{
  xresources.extraConfig = builtins.readFile (config.scheme base16-xresources);
}
