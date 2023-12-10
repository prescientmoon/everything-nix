{ pkgs, lib, ... }:
let vimclipRaw = pkgs.stdenv.mkDerivation rec {
  name = "vimclip";
  rev = "52003cc31e6e1d20550cdf6b7d3bf1a019a34fa0";

  src = pkgs.fetchFromGitHub {
    inherit rev;
    owner = "hrantzsch";
    repo = "vimclip";
    sha256 = "1ifsiiafvby8z9gp1x6fpfwklr6k9mg5vrajw9di06yixmrxzw7g";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ./vimclip $out/bin/vimclip
    chmod +x $out/bin/vimclip
  '';

  meta.mainProgram = "vimclip";
}; in
pkgs.writeShellScriptBin "vimclip" ''
  if [ "wayland" = $XDG_SESSION_TYPE ]
  then
    export VIMCLIP_CLIPBOARD_COMMAND=${pkgs.wl-clipboard}/bin/wl-copy
  else
    export VIMCLIP_CLIPBOARD_COMMAND=${pkgs.xsel}/bin/xsel
  fi

  ${lib.getExe vimclipRaw}
''
