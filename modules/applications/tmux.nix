{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;
in
{
  home-manager.users.adrielus.programs = {
    # Add tmux-navigator plugin to neovim
    neovim.extraPackages = [ pkgs.vimPlugins.vim-tmux-navigator ];

    tmux = {
      enable = true;

      clock24 = true; # 24h clock format
      terminal = "screen-256color"; # more colors
      historyLimit = 10000; # increase amount of saved lines

      plugins = with pkgs.tmuxPlugins; [
        cpu # Show CPU load with easy icons
        vim-tmux-navigator # Switch between tmux and vim panes with ease
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
