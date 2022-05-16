{ pkgs, lib, paths, ... }:
let
  paq = pkgs.fetchFromGitHub {
    owner = "savq";
    repo = "paq-nvim";
    rev = "cbbb8a550e35b1e6c9ddf7b098b25e6c2d8b1e86";
    sha256 = "0fsbww2kqwayi1azhglsjal6mwh68n03ylxxqzq17v7sar17vx4c";
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

    # Formatters
    luaformatter # lua
    ormolu # haskell
    prettierd # prettier but faster

    # Others
    fd # file finder
    ripgrep # grep rewrite (I think?)
    nodePackages.typescript # typescript language
    update-nix-fetchgit # useful for nix stuff
    tree-sitter # syntax highlighting

    texlive.combined.scheme-full # latex stuff
    python38Packages.pygments # required for latex syntax highlighting
  ];

  myConfig = ''
    vim.g.lualineTheme = ${theme.neovim.lualineTheme}
    vim.opt.runtimepath:append("${paths.dotfiles}/neovim")
    -- dofile("${paths.dotfiles}/neovim/my/init.lua").setup()
    require("my.init").setup()
  '';

  base = pkgs.neovim-nightly;
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
in
{
  home-manager.users.adrielus =
    {
      home.file.".local/share/nvim/site/pack/paqs/start/paq-nvim".source = paq;
      xdg.configFile."nvim/init.lua".text = myConfig;
      xdg.configFile."nvim/lua/my/theme.lua".source = theme.neovim.theme;
      home.packages = [ neovim ];

      programs.neovim = {
        enable = false;
      };
    };
}
