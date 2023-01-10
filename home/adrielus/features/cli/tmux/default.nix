{ pkgs, config,  ... }:
let
  base16-tmux = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-tmux";
    sha256 = "1p6czpd9f0sbibdsph1hdw4ljp6zzjij2159bks16wbfbg3p1hhx";
    rev = "3312bb2cbb26db7eeb2d2235ae17d4ffaef5e59b";
  };
in
{
  programs.tmux = {
    enable = true;

    clock24 = true; # 24h clock format
    historyLimit = 10000; # increase amount of saved lines

    plugins = with pkgs.tmuxPlugins; [
      sessionist # Nicer workflow for switching around between sessions
      resurrect # Save / restore tmux sessions
      {
        plugin = continuum; # Automatically restore tmux sessions
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
        '';
      }
    ];

    extraConfig = ''
      # Main config
      source ${./tmux.conf}

      # Theme
      source ${config.scheme base16-tmux}
    '';
  };
}
