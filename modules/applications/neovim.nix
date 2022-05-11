{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;

  # config-nvim = "/etc/nixos/configuration/dotfiles/neovim";
  config-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "config-nvim";
    src = ../../dotfiles/neovim;
  };

  # Lua code for importing a theme
  loadTheme = (theme: ''
    ${theme.neovim.theme}

    vim.g.lualineTheme = ${theme.neovim.lualineTheme}
  '');

  # Wrap a piece of lua code
  lua = (code: ''
    lua << EOF
    ${code}
    EOF
  '');
in
{
  home-manager.users.adrielus.programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    extraConfig = ''
      ${lua (loadTheme theme)}
      luafile ${config-nvim}/init.lua
    '';

    extraPackages = with pkgs; [
      # Language servers
      # haskellPackages.agda-language-server # agda
      nodePackages.typescript-language-server # typescript
      easy-purescript-nix.purescript-language-server # purescript
      sumneko-lua-language-server # lua
      rnix-lsp # nix
      haskell-language-server # haskell

      # Formatters
      luaformatter # lua
      ormolu # haskell
      prettierd # prettier but faster

      # Others
      fd # file finder
      ripgrep # grep rewrite (I think?)
      nodePackages.typescript # typescript language
      update-nix-fetchgit # useful for nix stuff

      texlive.combined.scheme-full # latex stuff
      python38Packages.pygments # required for latex syntax highlighting
    ];

    plugins = with pkgs.vimPlugins;
      with pkgs.vimExtraPlugins; with pkgs.myVimPlugins; theme.neovim.plugins ++ [
        config-nvim # my neovim config
        nvim-lspconfig # configures lsps for me
        nvim-autopairs # close pairs for me
        telescope-nvim # fuzzy search for say opening files
        purescript-vim # purescript syntax highlighting
        nvim-comment # allows toggling line-comments
        nvim-treesitter # use treesitter for syntax highlighting
        nvim-treesitter-textobjects # the lean plugin told me to add this
        startup-nvim # splash screen
        vim-devicons # nice looking icons
        nvim-web-devicons # fork of vim-devicons?
        plenary-nvim # async utility lib it seems?
        lualine-nvim # customizable status line
        nvim-tree-lua # file tree
        vimtex # latex plugin
        null-ls-nvim # generic language server
        telescope-file-browser-nvim # file creation/deletion using telescope
        lspkind-nvim # show icons in lsp completion menus
        # symbols-outline-nvim # tree view for symbols in document
        vimux # interact with tmux from within vim
        vim-tmux-navigator # easly switch between tmux and vim panes
        arpeggio # allows me to setup chord keybinds (keybinds where all the keys are pressed at the same time)
        presence-nvim # discord rich presence
        agda-nvim # agda support
        unicode-vim # better unicode support
        lean-nvim # lean support
        kmonad # support for the kmonad config language
        lh-vim-lib # dependency for lh-brackets
        lh-brackets # bracket customization

        # Cmp related stuff. See https://github.com/hrsh7th/nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        nvim-cmp # completion engine
        luasnip # snippet engine
      ];
  };
}
