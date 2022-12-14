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
    nodePackages.typescript-language-server # typescript
    easy-purescript-nix.purescript-language-server # purescript
    sumneko-lua-language-server # lua
    rnix-lsp # nix
    haskell-language-server # haskell
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
    update-nix-fetchgit # useful for nix stuff
    tree-sitter # syntax highlighting
    libstdcxx5 # required by treesitter aparently
    zathura # pdf reader
    xdotool # for zathura reverse search or whatever it's called

    texlive.combined.scheme-full # latex stuff
    python38Packages.pygments # required for latex syntax highlighting
  ];


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

  nixPlugins = ".local/share/nvim/site/pack/nix";
in
{
  home-manager.users.adrielus = { config, ... }:
    let simlink = config.lib.file.mkOutOfStoreSymlink; in
    {
      home.file.".local/share/nvim/site/pack/paqs/start/paq-nvim".source = paq;
      home.file."${nixPlugins}/start/theming/lua/my/theme.lua".source = theme.neovim.theme;
      home.file."${nixPlugins}/start/snippets".source = simlink "${paths.dotfiles}/vscode-snippets";
      home.file.".config/nvim".source = simlink "${paths.dotfiles}/neovim";

      programs.neovim.enable = false;

      home.packages = [
        neovim
      ];
    };
}
