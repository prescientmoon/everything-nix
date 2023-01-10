{ pkgs, lib, config, paths, ... }:
let
  devMode = false;
  extraPackages = with pkgs; [
    # Language servers
    nodePackages.typescript-language-server # typescript
    nodePackages_latest.purescript-language-server # purescript
    sumneko-lua-language-server # lua
    rnix-lsp # nix
    haskell-language-server # haskell
    tectonic # something related to latex (?)
    texlab # latex
    nodePackages_latest.vscode-langservers-extracted

    # Formatters
    luaformatter # Lua
    stylua # Lua
    ormolu # Haskell
    nodePackages_latest.purs-tidy # Purescript
    nodePackages_latest.prettier_d_slim # Js & friends

    # Others
    nodePackages.typescript # typescript
    wakatime # time tracking
    fd # file finder
    ripgrep # Grep rewrite
    update-nix-fetchgit # Useful for nix stuff
    tree-sitter # Syntax highlighting
    libstdcxx5 # Required by treesitter aparently
    zathura # Pdf reader
    xdotool # For zathura reverse search or whatever it's called
    lua # For repls and whatnot
    glow #Mmd preview in terminal
    pandoc # Md processing
    libsForQt5.falkon # Aparently needed for md preview

    texlive.combined.scheme-full # Latex stuff
    python38Packages.pygments # required for latex syntax highlighting
  ];
in
let
  simlink = config.lib.file.mkOutOfStoreSymlink;

  extraRuntime = [
    (if devMode
      then simlink "${paths.dotfiles}/vscode-snippets"
      else ../../../../dotfiles/vscode-snippets)
  ];

  # Wraps a neovim client, providing the dependencies
  # and setting some flags:
  #
  #   TODO: change this to a more general thing like "NVIM_CLIENT_NAME"
  # - INSIDE_NEOVIDE is used to detect when running inside neovide, 
  #   before the in-client flag gets set (this was causing me problems in the past)
  #
  # - NVIM_EXTRA_RUNTIME provides extra directories to add to the runtimepath. 
  #   I cannot just install those dirs using the builtin package support because 
  #   my package manager (lazy.nvim) disables those.
  wrapClient = { base, name }:
    pkgs.symlinkJoin {
      inherit (base) name meta;
      paths = [ base ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${name} \
          --prefix PATH : ${lib.makeBinPath extraPackages} \
          --set INSIDE_NEOVIDE ${if name == "neovide" then "1" else "0"} \
          --set NVIM_EXTRA_RUNTIME ${lib.strings.concatStringsSep "," extraRuntime}
      '';
    };

  neovim = wrapClient { base = pkgs.neovim-nightly; name = "nvim"; };
  neovide = wrapClient { base = pkgs.neovide; name = "neovide"; };
in
{
  # Do not manage neovim via nix
  programs.neovim.enable = false;

  home.file.".config/nvim".source =
    if devMode then
      simlink "${paths.dotfiles}/neovim" else
      ../../../../dotfiles/neovim;

  home.packages = [
    neovim
    neovide
  ];
}
