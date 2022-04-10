{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  name = "vimclip";
  rev = "7f53433";
  src = pkgs.fetchFromGitHub {
    inherit rev;
    owner = "hrantzsch";
    repo = "vimclip";
    sha256 = "cl5y7Lli5frwx823hoN17B2aQLNY7+njmKEDdIbhc4Y=";
  };

  buildInputs = [
    pkgs.makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./vimclip $out/bin/vimclip
    chmod +x $out/bin/vimclip
  '';

  postFixup = ''
    wrapProgram $out/bin/vimclip \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.xsel ]} \
      --set EDITOR nvim
  '';
}
