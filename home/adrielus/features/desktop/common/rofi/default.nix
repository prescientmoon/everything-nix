{ pkgs, config, ... }:
let
  base16-rofi = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-rofi";
    sha256 = "03y4ydnd6sijscrrp4qdvckrckscd39r8gyhpzffs60a1w4n76j5";
    rev = "3f64a9f8d8cb7db796557b516682b255172c4ab4";
  };
in
{
  home.packages = with pkgs; [ rofi ];

  xdg.configFile."rofi/config.rasi".text = ''
    // Manual config
    ${builtins.readFile ./config.rasi}

    // Inject font
    configuration {
      font = ${config.fontProfiles.monospace.family};
    }

    // Theme
    ${builtins.readFile (config.scheme base16-rofi)}
  '';
}
