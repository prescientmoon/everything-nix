{ pkgs, lib, paths, ... }:
let
  paq = pkgs.fetchFromGitHub {
    owner = "savq";
    repo = "paq-nvim";
    rev = "0ed94d59e315e066ced3f453ff00c0ae94938f1e";
    sha256 = "0dsq6cjm7jm7jh9dfxym4ipkp46fvw1lr9z98zd80im18rg4fg63";
  };

  teal = pkgs.fetchFromGitHub {
    owner = "teal-language";
    repo = "tl";
    rev = "526fe3640fe6265706541c251e984c033a1a5ec9";
    sha256 = "0l31qj492iaiadpp4s0wflfb7vn6zzxwhbiyczisdgpd9ydj20gf";
  };

  lazy-nvim = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "lazy.nvim";
    rev = "511524ebff27ed8dea9e8d2eadb26ef19fb322c7";
    sha256 = "0c8hfhrj2rfkpff0kwiv5g5bpvdq36b4xzsi8199jrpfvvp79302";
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
    nodePackages_latest.vscode-langservers-extracted

    # Formatters
    luaformatter # lua
    stylua # lua
    ormolu # haskell
    easy-purescript-nix.purs-tidy
    nodePackages_latest.prettier_d_slim

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
    lua # for repls and whatnot
    glow # md preview in terminal
    pandoc # md processing
    libsForQt5.falkon # aparently needed for md preview
    luajitPackages.luarocks # lua package manager

    texlive.combined.scheme-full # latex stuff
    python38Packages.pygments # required for latex syntax highlighting
  ];


  wrapClient = { base, name }:
    pkgs.symlinkJoin {
      inherit (base) name meta;
      paths = [ base ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${name} \
          --prefix PATH : ${lib.makeBinPath extraPackages} \
          --set LAZY_NVIM_PATH ${lazy-nvim} 
      '';
    };

  neovim = wrapClient { base = pkgs.neovim-nightly; name = "nvim"; };
  neovide = wrapClient { base = pkgs.neovide; name = "neovide"; };

  nixPlugins = ".local/share/nvim/site/pack/nix";
in
{
  home-manager.users.adrielus = { config, ... }:
    let simlink = config.lib.file.mkOutOfStoreSymlink; in
    {
      home.file."${nixPlugins}/start/paq-nvim".source = paq;
      home.file."${nixPlugins}/start/theming/lua/my/theme.lua".source = theme.neovim.theme;
      home.file."${nixPlugins}/start/teal/lua".source = teal; # teal (typed lua)
      home.file."${nixPlugins}/start/snippets".source = simlink "${paths.dotfiles}/vscode-snippets";
      # home.file.".config/nvim".source = simlink "${paths.dotfiles}/neovim";
      home.file.".config/nvim".source = ../../dotfiles/neovim;

      programs.neovim.enable = false;

      home.packages = [
        neovim
        neovide
      ];
    };
}
