{ pkgs, lib, ... }:
let
  sourceTmuxTheme = (theme: ''
    # Only load this theme if it's the current one
    if '[[ "$THEME" =~ ${theme.name} ]]' 'source ${theme.tmux.path}'
  '');
  tmuxThemes = pkgs.myHelpers.mergeLines (lib.lists.forEach pkgs.myThemes sourceTmuxTheme);
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
        # Load every theme available
        ${tmuxThemes}

        # load the rest of the config
        source-file ${../../dotfiles/tmux/tmux.conf}
      '';
    };
  };
}
