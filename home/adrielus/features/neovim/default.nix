{ pkgs, lib, config, paths, ... }:
let
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
    nodePackages_latest.prettier # Js & friends
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

    # Required by magma-nvim:
    # python310Packages.pynvim
    # python310Packages.jupyter
  ];
in
let
  extraRuntime = env: [
    # Snippets
    (config.satellite-dev.path "dotfiles/vscode-snippets")

    # Base16 theme
    (pkgs.writeTextDir
      "lua/nix/theme.lua"
      ''
        return {
          name = "${config.scheme.scheme}"
        }
      '')

    # Provide hints as to what app we are in
    # (Useful because neovide does not provide the info itself right away)
    (pkgs.writeTextDir
      "lua/nix/env.lua"
      "return '${env}'"
    )
  ];

  # Wraps a neovim client, providing the dependencies
  # and setting some flags:
  #
  # - NVIM_EXTRA_RUNTIME provides extra directories to add to the runtimepath. 
  #   I cannot just install those dirs using the builtin package support because 
  #   my package manager (lazy.nvim) disables those.
  wrapClient = { base, name, extraArgs ? "" }:
    pkgs.symlinkJoin {
      inherit (base) name meta;
      paths = [ base ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${name} \
          --prefix PATH : ${lib.makeBinPath extraPackages} \
          --set NVIM_EXTRA_RUNTIME ${lib.strings.concatStringsSep "," (extraRuntime name)} \
          ${extraArgs}
      '';
    };

  neovim = wrapClient { base = pkgs.neovim-nightly; name = "nvim"; };
  neovide = wrapClient {
    base = pkgs.neovide;
    name = "neovide";
    extraArgs = "--set NEOVIDE_MULTIGRID true";
  };
in
{
  # Do not manage neovim via nix
  programs.neovim.enable = false;

  home.file.".config/nvim".source = config.satellite-dev.path "dotfiles/neovim";
  home.sessionVariables.EDITOR = "nvim";

  home.packages = [
    neovim
    neovide
  ];
}
