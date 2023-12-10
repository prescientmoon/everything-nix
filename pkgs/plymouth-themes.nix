{ pkgs ? import <nixpkgs> { }
}:
# See [this blog post](http://blog.sidhartharya.com/using-custom-plymouth-theme-on-nixos/)
let mkTheme = { themeName, pack }: pkgs.stdenv.mkDerivation {
  pname = "adi1090x-plymouth-${themeName}";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
    sha256 = "0scgba00f6by08hb14wrz26qcbcysym69mdlv913mhm3rc1szlal";
  };

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
  '';

  installPhase =
    let path = "pack_${pack}/${themeName}";
    in
    ''
      cp -r ${path} $out/share/plymouth/themes
      cat ${path}/${themeName}.plymouth  \
        | sed  "s@\/usr\/@$out\/@" \
        > $out/share/plymouth/themes/${themeName}/${themeName}.plymouth
    '';
}; in
{
  cuts_alt = mkTheme { themeName = "cuts_alt"; pack = "1"; };
}
