{ pkgs, lib, ... }:
let vimclip = pkgs.stdenv.mkDerivation rec {
  name = "vimclip";
  rev = "7f53433";

  src = pkgs.fetchFromGitHub {
    inherit rev;
    owner = "hrantzsch";
    repo = "vimclip";
    sha256 = "cl5y7Lli5frwx823hoN17B2aQLNY7+njmKEDdIbhc4Y=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ./vimclip $out/bin/vimclip
    chmod +x $out/bin/vimclip
  '';
}; in
pkgs.writeShellScriptBin "vimclip" ''
  if ["wayland" = $XDG_SESSION_TYPE]
  then
    export VIMCLIP_CLIPBOARD_COMMAND=${pkgs.wl-clipboard}/bin/wl-copy
  else
    export VIMCLIP_CLIPBOARD_COMMAND=${lib.getExe pkgs.xsel}
  fi

  ${lib.getExe vimclip}
''
