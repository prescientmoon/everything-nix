{ pkgs, lib, paths, ... }:
let
  paq = pkgs.fetchFromGitHub {
    owner = "savq";
    repo = "paq-nvim";
    rev = "bc5950b990729464f2493b1eaab5a7721bd40bf5";
    sha256 = "0rsv3j5rxfv7ys9zvq775f63vy6w880b0xhyr164y8fcadhpypb3";
  };

  theme = pkgs.myThemes.current;

  extraPackages = with pkgs; [
    # Language servers
    # haskellPackages.agda-language-server # agda
    nodePackages.typescript-language-server # typescript
    easy-purescript-nix.purescript-language-server # purescript
    sumneko-lua-language-server # lua
    rnix-lsp # nix
    haskell-language-server # haskell
    kotlin-language-server # kotlin
    tectonic # also latex something?
    texlab # latex
    # vscode-langservers-extracted # css and shit

    # Formatters
    luaformatter # lua
    ormolu # haskell
    easy-purescript-nix.purs-tidy
    # prettierd # prettier but faster

    # Others
    nodePackages.typescript # typescript
    wakatime # time tracking
    fd # file finder
    ripgrep # grep rewrite (I think?)
    nodePackages.typescript # typescript language
    update-nix-fetchgit # useful for nix stuff
    tree-sitter # syntax highlighting
    libstdcxx5 # required by treesitter aparently

    texlive.combined.scheme-full # latex stuff
    python38Packages.pygments # required for latex syntax highlighting
  ];

  myConfig = ''
    vim.g.lualineTheme = "${theme.neovim.lualineTheme}"
    vim.opt.runtimepath:append("${paths.dotfiles}/neovim")
    vim.opt.runtimepath:append("${paths.dotfiles}/vscode-snippets")
    require("my.init").setup()
  '';

  base = pkgs.neovim-nightly;
  # base = pkgs.neovim;
  neovim =
    pkgs.symlinkJoin {
      inherit (base) name meta;
      paths = [ base ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/nvim \
          --prefix PATH : ${lib.makeBinPath extraPackages}
      '';
    };
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars);
in
{
  home-manager.users.adrielus =
    {
      home.file.".local/share/nvim/site/pack/paqs/start/paq-nvim".source = paq;
      # home.file.".local/share/nvim/site/pack/treesitter/start/nvim-treesitter".source = nvim-treesitter;
      xdg.configFile."nvim/init.lua".text = myConfig;
      xdg.configFile."nvim/lua/my/theme.lua".source = theme.neovim.theme;

      programs.neovim.enable = false;

      home.packages = [
        neovim
      ];
    };
}
