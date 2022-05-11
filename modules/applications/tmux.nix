{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;

  fastcopy = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "fastcopy";
      version = "unstable-2022-04-18";
      src = pkgs.fetchFromGitHub
        {
          owner = "abhinav";
          repo = "tmux-fastcopy";
          sha256 = "0d2xdch5w35mw3kpw1y6jy8wk4zj43pjx73jlx83ciqddl3975x6";
          rev = "4b9bc8e9e71c5b6eeb44a02f608baec07e12ea3d";
        };
    };
in
{
  home-manager.users.adrielus.programs = {
    # Add tmux-navigator plugin to neovim
    # neovim.extraPackages = [ pkgs.vimPlugins.vim-tmux-navigator ];

    tmux = {
      enable = true;

      clock24 = true; # 24h clock format
      terminal = "screen-256color"; # more colors
      historyLimit = 10000; # increase amount of saved lines

      plugins = with pkgs.tmuxPlugins; [
        cpu # Show CPU load with easy icons
        vim-tmux-navigator # Switch between tmux and vim panes with ease
        sessionist # Nicer workflow for switching around between session
        # fastcopy # Easy copying of stuff
        resurrect # Save / restore tmux sessions
      ];

      extraConfig = ''
        # Load current theme
        source ${theme.tmux.path}

        # load the rest of the config
        source ${../../dotfiles/tmux/tmux.conf}
      '';
    };
  };
}
