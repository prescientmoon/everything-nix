{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;

  fastcopy = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "fastcopy";
      version = "unstable-2022-11-16";
      src = pkgs.fetchFromGitHub
        {
          owner = "abhinav";
          repo = "tmux-fastcopy";
          sha256 = "1ald4ycgwj1fhk82yvsy951kgnn5im53fhsscz20hvjsqql7j4j3";
          rev = "41f4c1c9fae7eb05c85ee2e248719f004dcfc90e";
        };
    };

  cowboy = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "cowboy";
      version = "unstable-2021-05-11";
      src = pkgs.fetchFromGitHub
        {
          owner = "tmux-plugins";
          repo = "tmux-cowboy";
          sha256 = "16wqwfaqy7nhiy1ijkng1x4baqq7s9if0m3ffcrnakza69s6r4r8";
          rev = "75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
        };
    };

  muxile = pkgs.callPackage ./tmux/muxile.nix { };
in
{
  home-manager.users.adrielus.programs = {
    # Add tmux-navigator plugin to neovim
    # neovim.extraPackages = [ pkgs.vimPlugins.vim-tmux-navigator ];

    tmux = {
      enable = true;

      clock24 = true; # 24h clock format
      # terminal = "screen-256color"; # more colors
      historyLimit = 10000; # increase amount of saved lines

      plugins = with pkgs.tmuxPlugins; [
        # cpu # Show CPU load with easy icons
        # vim-tmux-navigator # Switch between tmux and vim panes with ease
        sessionist # Nicer workflow for switching around between session
        # fastcopy # Easy copying of stuff
        resurrect # Save / restore tmux sessions
        # muxile # Track tmux sessions on my phone
        # cowboy # kill all hanging processes inside pane
        {
          plugin = continuum; # start tmux on boot & more
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
          '';
        }
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

